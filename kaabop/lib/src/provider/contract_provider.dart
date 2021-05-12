import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/models/token.m.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import '../../index.dart';

class ContractProvider with ChangeNotifier {
  final WalletSDK sdk = ApiProvider.sdk;
  final Keyring keyring = ApiProvider.keyring;
  String ethAdd = '';

  Atd atd = Atd();
  Kmpi kmpi = Kmpi();
  bool isReady = false;
  NativeM bscNative = NativeM(
    id: 'selendra',
    logo: 'assets/SelendraCircle-Blue.png',
    symbol: 'SEL',
    org: 'BEP-20',
    isContain: true,
  );

  NativeM kgoNative = NativeM(
    id: 'kiwigo',
    logo: 'assets/Kiwi-GO-White-1.png',
    symbol: 'KGO',
    org: 'BEP-20',
    isContain: true,
  );

  NativeM etherNative = NativeM(
    id: 'etheruem',
    logo: 'assets/eth.png',
    symbol: 'ETH',
    org: '',
    isContain: true,
  );

  NativeM bnbNative = NativeM(
    id: 'binance smart chain',
    logo: 'assets/bnb.png',
    symbol: 'BNB',
    org: 'Smart Chain',
    isContain: true,
  );
  Client _httpClient;
  Web3Client _web3client, _etherClient;

  List<TokenModel> token = [];

  Future<void> initClient() async {
    _httpClient = Client();
    _web3client = Web3Client(AppConfig.bscMainNet, _httpClient);
  }

  Future<void> initEtherClient() async {
    _httpClient = Client();
    _etherClient = Web3Client(AppConfig.etherMainet, _httpClient);
  }

  Future<void> getEtherBalance() async {
    initEtherClient();

    final ethAddr = await StorageServices().readSecure('etherAdd');
    final EtherAmount ethbalance =
        await _etherClient.getBalance(EthereumAddress.fromHex(ethAddr));
    etherNative.balance = ethbalance.getValueInUnit(EtherUnit.ether).toString();

    notifyListeners();
  }

  Future<DeployedContract> initBsc(String contractAddr) async {
    final String abiCode = await rootBundle.loadString('assets/abi/abi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'BEP-20'),
      EthereumAddress.fromHex(contractAddr),
    );

    return contract;
  }

  Future<List> query(
      String contractAddress, String functionName, List args) async {
    initClient();
    final contract = await initBsc(contractAddress);
    final ethFunction = contract.function(functionName);

    final res = await _web3client.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );
    return res;
  }

  Future<void> getKgoSymbol() async {
    final res = await query(AppConfig.kgoAddr, 'symbol', []);

    kgoNative.symbol = res[0].toString();
    kgoNative.isContain = true;
    notifyListeners();
  }

  Future<void> getKgoDecimal() async {
    final res = await query(AppConfig.kgoAddr, 'decimals', []);
    kgoNative.chainDecimal = res[0].toString();

    notifyListeners();
  }

  Future<void> getKgoBalance() async {
    bscNative.isContain = true;
    final res = await query(
        AppConfig.kgoAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

    kgoNative.balance = Fmt.bigIntToDouble(
      res[0] as BigInt,
      int.parse(kgoNative.chainDecimal),
    ).toString();

    notifyListeners();
  }

  Future<void> getBscDecimal() async {
    final res = await query(AppConfig.bscMainnetAddr, 'decimals', []);

    bscNative.chainDecimal = res[0].toString();

    notifyListeners();
  }

  Future<void> getSymbol() async {
    final res = await query(AppConfig.bscMainnetAddr, 'symbol', []);

    bscNative.symbol = res[0].toString();
    notifyListeners();
  }

  Future<void> extractAddress(String privateKey) async {
    initClient();
    final credentials = await _web3client.credentialsFromPrivateKey(
      privateKey,
    );

    if (credentials != null) {
      final addr = await credentials.extractAddress();
      await StorageServices().writeSecure('etherAdd', addr.toString());
    }
  }

  Future<void> getEtherAddr() async {
    final ethAddr = await StorageServices().readSecure('etherAdd');
    ethAdd = ethAddr;

    notifyListeners();
  }

  Future<void> getBnbBalance() async {
    bnbNative.isContain = true;
    final ethAddr = await StorageServices().readSecure('etherAdd');
    final balance = await _web3client.getBalance(
      EthereumAddress.fromHex(ethAddr),
    );

    bnbNative.balance = balance.getValueInUnit(EtherUnit.ether).toString();

    notifyListeners();
  }

  Future<void> getBscBalance() async {
    bscNative.isContain = true;
    await getBscDecimal();
    final res = await query(AppConfig.bscMainnetAddr, 'balanceOf',
        [EthereumAddress.fromHex(ethAdd)]);
    bscNative.balance = Fmt.bigIntToDouble(
      res[0] as BigInt,
      int.parse(bscNative.chainDecimal),
    ).toString();

    notifyListeners();
  }

  Future<void> fetchNonBalance() async {
    initClient();
    for (int i = 0; i < token.length; i++) {
      final contractAddr = findContractAddr(token[i].symbol);
      final decimal = await query(contractAddr, 'decimals', []);

      final balance = await query(
          contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

      token[i].balance = Fmt.bigIntToDouble(
        balance[0] as BigInt,
        int.parse(decimal[0].toString()),
      ).toString();
    }

    notifyListeners();
  }

  Future<String> sendTxBnb(
    String privateKey,
    String reciever,
    String amount,
  ) async {
    initClient();
    final credentials = await _web3client.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final res = await _web3client.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(reciever),
        value:
            EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
      ),
      fetchChainIdFromNetworkId: true,
    );

    return res;
  }

  Future<String> sendTxEther(
    String privateKey,
    String reciever,
    String amount,
  ) async {
    initEtherClient();
    final credentials = await _web3client.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final res = await _etherClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(reciever),
        value:
            EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
      ),
      fetchChainIdFromNetworkId: true,
    );
    return res;
  }

  Future<String> sendTxBsc(
    String contractAddr,
    String chainDecimal,
    String privateKey,
    String reciever,
    String amount,
  ) async {
    initClient();

    final contract = await initBsc(contractAddr);
    final txFunction = contract.function('transfer');
    final credentials = await _web3client.credentialsFromPrivateKey(privateKey);

    final res = await _web3client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: txFunction,
        parameters: [
          EthereumAddress.fromHex(reciever),
          BigInt.from(
            pow(
              double.parse(amount) * 10,
              int.parse(chainDecimal),
            ),
          ),
        ],
      ),
      fetchChainIdFromNetworkId: true,
    );

    return res;
  }

  Future<void> initKmpi() async {
    kmpi.isContain = true;
    kmpi.logo = 'assets/koompi_white_logo.png';
    kmpi.symbol = 'KMPI';
    kmpi.org = 'KOOMPI';
    kmpi.id = 'koompi';

    await sdk.api.callContract();
    await fetchKmpiHash();
    fetchKmpiBalance();
    notifyListeners();
  }

  Future<void> fetchKmpiHash() async {
    final res =
        await sdk.api.getHashBySymbol(keyring.current.address, kmpi.symbol);
    kmpi.hash = res.toString();
  }

  Future<void> fetchKmpiBalance() async {
    final res = await sdk.api.balanceOfByPartition(
        keyring.current.address, keyring.current.address, kmpi.hash);
    kmpi.balance = BigInt.parse(res['output'].toString()).toString();

    notifyListeners();
  }

  Future<void> initAtd() async {
    atd.isContain = true;
    atd.logo = 'assets/FingerPrint1.png';
    atd.symbol = 'ATD';
    atd.org = 'KOOMPI';
    atd.id = 'koompi';

    await sdk.api.initAttendant();
    notifyListeners();
  }

  Future<void> fetchAtdBalance() async {
    final res = await sdk.api.getAToken(keyring.current.address);
    atd.balance = BigInt.parse(res).toString();

    notifyListeners();
  }

  Future<void> addToken(String symbol, BuildContext context,
      {String contractAddr}) async {
    if (symbol == 'KMPI') {
      if (!kmpi.isContain) {
        initKmpi().then((value) async {
          await StorageServices.saveBool(kmpi.symbol, true);
        });
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);
      }
    } else if (symbol == 'SEL') {
      if (!bscNative.isContain) {
        bscNative.isContain = true;

        await StorageServices.saveBool('SEL', true);

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol("$symbol (BEP-20)");

        await getSymbol();
        await getBscDecimal();
        await getBscBalance();
      }
    } else if (symbol == 'BNB') {
      if (!bnbNative.isContain) {
        bnbNative.isContain = true;

        await StorageServices.saveBool('BNB', true);

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);

        await getBscDecimal();
        getBnbBalance();
      }
    } else if (symbol == 'ATD') {
      if (!atd.isContain) {
        initAtd().then((value) async {
          await StorageServices.saveBool(atd.symbol, true);
          Provider.of<WalletProvider>(context, listen: false)
              .addTokenSymbol(symbol);
        });
      }
    } else if (symbol == 'DOT') {
      if (!ApiProvider().dot.isContain) {
        await StorageServices.saveBool('DOT', true);

        ApiProvider().connectPolNon();
        //Provider.of<ApiProvider>(context, listen: false).isDotContain();
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);
      }
    } else if (symbol == 'KGO') {
      if (!ApiProvider().dot.isContain) {
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('KGO (BEP-20)');
        Provider.of<ContractProvider>(context, listen: false).getKgoSymbol();
        Provider.of<ContractProvider>(context, listen: false)
            .getKgoDecimal()
            .then((value) {
          Provider.of<ContractProvider>(context, listen: false).getKgoBalance();
        });
      }
    } else {
      final symbol = await query(contractAddr, 'symbol', []);
      final decimal = await query(contractAddr, 'decimals', []);
      final balance = await query(
          contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

      if (token.isNotEmpty) {
        final TokenModel item = token.firstWhere(
            (element) =>
                element.symbol.toLowerCase() ==
                symbol[0].toString().toLowerCase(),
            orElse: () => null);

        if (item == null) {
          addContractToken(
            TokenModel(
              contractAddr: contractAddr,
              decimal: decimal[0].toString(),
              symbol: symbol[0].toString(),
              balance: balance[0].toString(),
              org: 'BEP-20',
            ),
          );

          await StorageServices.saveContractAddr(contractAddr);
          Provider.of<WalletProvider>(context, listen: false)
              .addTokenSymbol('${symbol[0]} (BEP-20)');
        }
      } else {
        token.add(TokenModel(
            contractAddr: contractAddr,
            decimal: decimal[0].toString(),
            symbol: symbol[0].toString(),
            balance: balance[0].toString(),
            org: 'BEP-20'));

        await StorageServices.saveContractAddr(contractAddr);
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol[0].toString());
      }
    }
    notifyListeners();
  }

  Future<void> addContractToken(TokenModel tokenModel) async {
    token.add(tokenModel);
    notifyListeners();
  }

  Future<void> removeToken(String symbol, BuildContext context) async {
    if (symbol == 'KMPI') {
      kmpi.isContain = false;
      await StorageServices.removeKey('KMPI');
    } else if (symbol == 'ATD') {
      atd.isContain = false;
      await StorageServices.removeKey('ATD');
    } else if (symbol == 'SEL') {
      bscNative.isContain = false;
      await StorageServices.removeKey('SEL');
    } else if (symbol == 'BNB') {
      bnbNative.isContain = false;
      await StorageServices.removeKey('BNB');
    } else if (symbol == 'DOT') {
      await StorageServices.removeKey('DOT');
      Provider.of<ApiProvider>(context, listen: false).dotIsNotContain();
    } else {
      final mContractAddr = findContractAddr(symbol);
      await StorageServices.removeContractAddr(mContractAddr);
      token.removeWhere(
        (element) => element.symbol.toLowerCase().startsWith(
              symbol.toLowerCase(),
            ),
      );
    }
    if (symbol == 'SEL') {
      Provider.of<WalletProvider>(context, listen: false)
          .removeTokenSymbol("$symbol (BEP-20)");
    } else {
      Provider.of<WalletProvider>(context, listen: false)
          .removeTokenSymbol(symbol);
    }
    notifyListeners();
  }

  String findContractAddr(String symbol) {
    final item = token.firstWhere(
      (element) => element.symbol.toLowerCase().startsWith(
            symbol.toLowerCase(),
          ),
    );
    return item.contractAddr;
  }

  Future<void> getAStatus() async {
    final res = await sdk.api.getAStatus(keyring.keyPairs[0].address);
    atd.status = res;
    notifyListeners();
  }

  void setEtherMarket(
      Market ethMarket, String currentPrice, String priceChange24h) {
    etherNative.marketData = ethMarket;
    etherNative.marketPrice = currentPrice;
    etherNative.change24h = priceChange24h;
    notifyListeners();
  }

  void setBnbMarket(
      Market bnbMarket, String currentPrice, String priceChange24h) {
    bnbNative.marketData = bnbMarket;
    bnbNative.marketPrice = currentPrice;
    bnbNative.change24h = priceChange24h;
    notifyListeners();
  }

  void setkiwigoMarket(
      Market kgoMarket, String currentPrice, String priceChange24h) {
    kgoNative.marketData = kgoMarket;
    kgoNative.marketPrice = currentPrice;
    kgoNative.change24h = priceChange24h;
    notifyListeners();
  }

  void setReady() {
    isReady = true;

    notifyListeners();
  }

  void resetConObject() {
    atd = Atd();
    kmpi = Kmpi();
    bscNative = NativeM(
      id: 'selendra',
      symbol: 'SEL',
      logo: 'assets/SelendraCircle-Blue.png',
      org: 'BEP-20',
      isContain: true,
    );
    bnbNative = NativeM(
      id: 'binance smart chain',
      logo: 'assets/bnb.png',
      symbol: 'BNB',
      // org: 'Smart Chain',
      isContain: true,
    );

    token.clear();

    notifyListeners();
  }
}
