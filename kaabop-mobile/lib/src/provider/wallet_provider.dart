import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/models/fmt.dart';
import '../../index.dart';

class WalletProvider with ChangeNotifier {
  WalletSDK _sdk = WalletSDK();
  Keyring _keyring = Keyring();
  String _nativeBalance = '';
  bool _isApiConnected = false;
  bool _isSdkReady = false;
  List<PortfolioM> _portfolioM = [];
  List<Map<String, String>> availableToken = [];

  List<Color> pieColorList = [
    hexaCodeToColor("#08B952"),
    hexaCodeToColor("#40FF90"),
    hexaCodeToColor("#00FFF0"),
  ];

  Map<String, double> dataMap = {
    'SEL': 100,
    'KMPI': 0,
    'ATT': 0,
  };

  WalletSDK get sdk => _sdk;
  Keyring get keyring => _keyring;
  List<PortfolioM> get portfolio => _portfolioM;
  String get nativeBalance => _nativeBalance;
  bool get isApiConnected => _isApiConnected;

  Future<void> initApi() async {
    await keyring.init();
    await sdk.init(keyring);

    _isSdkReady = true;
    return _isSdkReady;
  }

  Future<void> connectNetwork() async {
    final node = NetworkParams();

    node.name = 'Indranet hosted By Selendra';
    node.endpoint = 'wss://rpc-testnet.selendra.org';
    node.ss58 = 42;

    final res = await sdk.api.connectNode(keyring, [node]);

    if (res != null) {
      _isApiConnected = true;
    }

    notifyListeners();
  }

  Future<void> subscribeBalance() async {
    await sdk.api.account.subscribeBalance(keyring.current.address, (res) {
      if (res != null) {
        _nativeBalance = Fmt.balance(res.freeBalance, 18);
      }
    });
    notifyListeners();
  }

  void addAvaibleToken(Map<String, String> token) {
    availableToken.add(token);
    notifyListeners();
  }

  void updateAvailableToken(Map<String, String> token) {
    if (availableToken.isEmpty) {
      addAvaibleToken(token);
    } else {
      for (int i = 0; i < availableToken.length; i++) {
        //print(availableToken[i]['symbol']);
        if (availableToken[i]['symbol'] == token['symbol']) {
          availableToken[i].update('balance', (value) => token['balance']);
        } else {
          addAvaibleToken(token);
        }
      }
    }
    notifyListeners();
  }

  void removeAvailableToken(Map<String, String> token) {
    availableToken.remove(token);
    notifyListeners();
  }

  void clearPortfolio() {
    availableToken.clear();
    _portfolioM.clear();
    notifyListeners();
  }

  Future<double> getTotal() async {
    double total = 0;
    //print(availableToken);
    for (int i = 0; i < availableToken.length; i++) {
      total = total + double.parse(availableToken[i]['balance']);
    }
    return total;
  }

  void resetDatamap() {
    dataMap.update('SEL', (value) => value = 100);
    dataMap.update('KMPI', (value) => value = 0);
    dataMap.update('ATT', (value) => value = 0);
    notifyListeners();
  }

  void getPortfolio() async {
    _portfolioM.clear();
    await getTotal().then((total) {
      for (int i = 0; i < availableToken.length; i++) {
        if (availableToken[i]['symbol'] == 'SEL') {
          var percen = double.parse(availableToken[i]['balance']) / total * 100;
          _portfolioM.add(PortfolioM(
            color: pieColorList[0],
            symbol: 'SEL',
            percentage: percen.toStringAsFixed(2),
          ));
          dataMap.update('SEL',
              (value) => value = double.parse(percen.toStringAsFixed(2)));
        } else if (availableToken[i]['symbol'] == 'KMPI') {
          var percen = double.parse(availableToken[i]['balance']) / total * 100;
          _portfolioM.add(PortfolioM(
              color: pieColorList[1],
              symbol: 'KMPI',
              percentage: percen.toStringAsFixed(2)));
          dataMap.update('KMPI',
              (value) => value = double.parse(percen.toStringAsFixed(2)));
        } else if (availableToken[i]['symbol'] == 'ATT') {
          var percen = double.parse(availableToken[i]['balance']) / total * 100;
          _portfolioM.add(PortfolioM(
              color: pieColorList[1],
              symbol: 'ATT',
              percentage: percen.toStringAsFixed(2)));
          dataMap.update('ATT',
              (value) => value = double.parse(percen.toStringAsFixed(2)));
        }
      }
    });
    notifyListeners();
  }
}
