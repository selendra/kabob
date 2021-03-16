import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/models/native.m.dart';

class ApiProvider with ChangeNotifier {
  WalletSDK sdk = WalletSDK();
  Keyring keyring = Keyring();

  AccountM accountM = AccountM();
  NativeM nativeM = NativeM(
    logo: 'assets/native_token.png',
    symbol: 'SEL',
    org: 'SELENDRA',
  );

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> initApi() async {
    await keyring.init();
    await sdk.init(keyring);
    getCurrentAccount();
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

  Future<void> getChainDecimal() async {
    final res = await sdk.api.getChainDecimal();
    nativeM.chainDecimal = res.toString();
    subscribeBalance();
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

  Future<void> getAddressIcon() async {
    final res = await sdk.api.account.getPubKeyIcons(
      [keyring.keyPairs[0].pubKey],
    );

    accountM.addressIcon = res.toString();
    notifyListeners();
  }

  Future<void> getCurrentAccount() async {
    accountM.address = keyring.keyPairs[0].address;
    accountM.name = keyring.keyPairs[0].name;
    notifyListeners();
  }
}
