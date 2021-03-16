import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/account.m.dart';

class ApiProvider with ChangeNotifier {
  WalletSDK sdk = WalletSDK();
  Keyring keyring = Keyring();

  AccountM accountM = AccountM();

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> initApi() async {
    await keyring.init();
    await FlutterWebviewPlugin().reload();
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

    // setState(() {});
    // if (res != null) {
    //   setState(() {
    //     _createAccModel.apiConnected = true;
    //   });
    //   getProfileIcon();
    //   await readContract();
    //   await readAtd();
    //   initContract();
    //   getChainDecimal();
    //   _subscribeBalance();
    // }
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
