import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/models/fmt.dart';

class WalletProvider with ChangeNotifier {
  WalletSDK _sdk = WalletSDK();
  Keyring _keyring = Keyring();
  String _nativeBalance = '';
  bool _isApiConnected = false;
  bool _isSdkReady = false;

  WalletSDK get sdk => _sdk;
  Keyring get keyring => _keyring;
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
    //  print(node.endpoint);

    final res = await sdk.api.connectNode(
      keyring,
      [node],
    );

    if (res != null) {
      _isApiConnected = true;
    } else {
      //  print('res null');
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
}
