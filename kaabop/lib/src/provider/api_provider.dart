import 'dart:math';

import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/models/native.m.dart';
import 'package:wallet_apps/src/models/token.m.dart';
import 'package:http/http.dart' as http;
import 'package:bitcoin_flutter/bitcoin_flutter.dart';

class ApiProvider with ChangeNotifier {
  static WalletSDK sdk = WalletSDK();
  static Keyring keyring = Keyring();

  static const int bitcoinDigit = 8;
  num bitcoinSatFmt = pow(10, 8);

  double amount = 0.0008;

  static List<TokenModel> listToken = [
    // TokenModel(
    //   logo: 'assets/FingerPrint1.png',
    //   symbol: 'ATD',
    //   org: 'KOOMPI',
    //   color: Colors.black,
    // ),
    // TokenModel(
    //   logo: 'assets/koompi_white_logo.png',
    //   symbol: 'KMPI',
    //   org: 'KOOMPI',
    //   color: Colors.transparent,
    // ),
    TokenModel(
      logo: 'assets/icons/polkadot.png',
      symbol: 'DOT',
      org: '',
      color: Colors.transparent,
    ),
    TokenModel(
      logo: 'assets/bnb-2.png',
      symbol: 'BNB',
      org: 'Smart Chain',
      color: Colors.transparent,
    ),
    TokenModel(
      logo: 'assets/SelendraCircle-Blue.png',
      symbol: 'SEL',
      org: 'BEP-20',
      color: Colors.transparent,
    ),
  ];

  ContractProvider contractProvider;
  AccountM accountM = AccountM();
  NativeM nativeM = NativeM(
    id: 'selendra',
    logo: 'assets/SelendraCircle-White.png',
    symbol: 'SEL',
    org: 'Testnet',
  );
  NativeM dot = NativeM(
    id: 'polkadot',
    symbol: 'DOT',
    logo: 'assets/icons/polkadot.png',
    isContain: false,
  );
  NativeM btc = NativeM(
      id: 'bitcoin',
      symbol: 'BTC',
      logo: 'assets/btc_logo.png',
      isContain: false);

  bool _isConnected = false;
  String btcAdd = '';

  bool get isConnected => _isConnected;

  Future<void> initApi() async {
    await keyring.init();
    keyring.setSS58(42);
    await sdk.init(keyring);
  }

  Future<NetworkParams> connectNode() async {
    final node = NetworkParams();

    node.name = AppConfig.nodeName;
    node.endpoint = AppConfig.nodeEndpoint;
    node.ss58 = AppConfig.ss58;

    final res = await sdk.api.connectNode(keyring, [node]);

    if (res != null) {
      _isConnected = true;
    }

    notifyListeners();

    return res;
  }

  Future<NetworkParams> connectPolNon() async {
    final node = NetworkParams();
    node.name = AppConfig.nodeName;
    node.endpoint = AppConfig.dotMainnet;
    node.ss58 = 0;

    final node1 = NetworkParams();
    node.name = 'Polkadot(Live, hosted by PatractLabs)';
    node.endpoint = 'wss://polkadot.elara.patract.io';
    node.ss58 = 0;

    final res = await sdk.api.connectNon(keyring, [node]);

    if (res != null) {
      _isConnected = true;

      getNChainDecimal();
    }

    notifyListeners();

    return res;
  }

  Future<bool> validateBtcAddr(String address) async {
    return Address.validateAddress(address, testnet);
  }

  void setBtcAddr(String btcAddress) {
    btcAdd = btcAddress;
    notifyListeners();
  }

  Future<int> sendTxBtc(BuildContext context, String from, String to,
      double amount, String wif) async {
    int totalSatoshi = 0;
    int input = 0;
    final alice = ECPair.fromWIF(wif);

    final txb = TransactionBuilder();
    txb.setVersion(1);

    final res = await getAddressUxto(from);

    if (res.length != 0) {
      for (final i in res) {
        if (i['status']['confirmed'] == true) {
          txb.addInput(
            i['txid'],
            int.parse(i['vout'].toString()),
          );
          totalSatoshi += int.parse(i['value'].toString());
          input++;
        }
      }
    }

    final totaltoSend = (amount * bitcoinSatFmt).floor();

    if (totalSatoshi < totaltoSend) {
      await customDialog(context,
          'You do not have enough in your wallet to send that much.', 'Opps');
    }

    final fee = calTrxSize(input, 2) * 88;

    if (fee > (amount * bitcoinSatFmt).floor()) {
      await customDialog(
          context,
          "BitCoin amount must be larger than the fee. (Ideally it should be MUCH larger)",
          'Opps');
    }

    final change = totalSatoshi - ((amount * bitcoinSatFmt).floor() + fee);

    txb.addOutput(to, totaltoSend);
    txb.addOutput(from, change);

    for (int i = 0; i < input; i++) {
      txb.sign(vin: i, keyPair: alice);
    }

    final response = await pushTx(txb.build().toHex());

    return response;
  }

  Future<void> customDialog(
      BuildContext context, String text1, String text2) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: Text(text1),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(text2),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<int> pushTx(String hex) async {
    final res =
        await http.post('https://api.smartbit.com.au/v1/blockchain/pushtx',
            //headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: json.encode({"hex": hex}));
    return res.statusCode;
  }

  int calTrxSize(int nInput, int nOutput) {
    return nInput * 180 + nOutput * 34 + 10 + nInput;
  }

  Future<dynamic> getAddressUxto(String address) async {
    final res =
        await http.get('https://blockstream.info/api/address/$address/utxo');

    return jsonDecode(res.body);
  }

  Future<void> getBtcFee() async {
    final res =
        await http.get('https://bitcoinfees.earn.com/api/v1/fees/recommended');

    //print(jsonDecode(res.body));
  }

  Future<void> getBtcBalance(String address) async {
    int totalSatoshi = 0;
    final res = await getAddressUxto(address);

    if (res.length == 0) {
      btc.balance = '0';
    } else {
      for (final i in res) {
        if (i['status']['confirmed'] == true) {
          totalSatoshi += int.parse(i['value'].toString());
        }
      }

      btc.balance = (totalSatoshi / bitcoinSatFmt).toString();
    }

    notifyListeners();
  }

  // void isDotContain() {
  //   dot.isContain = true;
  //   notifyListeners();
  // }

  void setDotMarket(
      Market marketData,List<List<double>> lineChartData, String currentPrice, String priceChange24h) {
    dot.marketData = marketData;
    dot.marketPrice = currentPrice;
    dot.change24h = priceChange24h;
    dot.lineChartData = lineChartData;

    notifyListeners();
  }

  void isBtcAvailable(String contain) {
    if (contain != null) {
      btc.isContain = true;
      notifyListeners();
    }
  }

  void setBtcMarket(
      Market marketData, List<List<double>> lineChartData, String currentPrice, String priceChange24h) {
    btc.marketData = marketData;
    btc.marketPrice = currentPrice;
    btc.change24h = priceChange24h;
    btc.lineChartData = lineChartData;

    notifyListeners();
  }

  void dotIsNotContain() {
    dot.isContain = false;
    notifyListeners();
  }

  Future<String> getPrivateKey(String mnemonic) async {
    final res = await ApiProvider.sdk.api.getPrivateKey(mnemonic);
    return res;
  }

  Future<bool> validateAddress(String address) async {
    final res = await sdk.api.keyring.validateAddress(address);
    return res;
  }

  Future<void> getChainDecimal() async {
    final res = await sdk.api.getChainDecimal();
    nativeM.chainDecimal = res[0].toString();

    subscribeBalance();
    notifyListeners();
  }

  Future<void> getNChainDecimal() async {
    final res = await sdk.api.getNChainDecimal();
    dot.chainDecimal = res[0].toString();
    subscribeNBalance();
    notifyListeners();
  }

  Future<void> subscribeBalance() async {
    await sdk.api.account.subscribeBalance(keyring.current.address, (res) {
      nativeM.balance = Fmt.balance(
        res.freeBalance.toString(),
        int.parse(nativeM.chainDecimal),
      );

      notifyListeners();
    });
  }

  Future<void> subscribeNBalance() async {
    await sdk.api.account.subscribeNBalance(keyring.current.address, (res) {
      dot.balance = Fmt.balance(
        res.freeBalance.toString(),
        int.parse(dot.chainDecimal),
      );
      notifyListeners();
    });
  }

  Future<void> getAddressIcon() async {
    final res = await sdk.api.account.getPubKeyIcons(
      [keyring.keyPairs[0].pubKey],
    );

    accountM.addressIcon = res.toString();
    notifyListeners();
  }

  Future<void> getCurrentAccount() async {
    accountM.address = keyring.current.address;
    accountM.name = keyring.current.name;
    notifyListeners();
  }

  void resetNativeObj() {
    accountM = AccountM();
    nativeM = NativeM(
      id: 'selendra',
      logo: 'assets/SelendraCircle-White.png',
      symbol: 'SEL',
      org: 'Testnet',
    );
    dot = NativeM();

    notifyListeners();
  }
}
