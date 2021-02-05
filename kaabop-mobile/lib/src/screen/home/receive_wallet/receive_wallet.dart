import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';

class ReceiveWallet extends StatefulWidget {
  final HomeModel homeM;
  final WalletSDK sdk;
  final Keyring keyring;

  ReceiveWallet({this.homeM, this.sdk, this.keyring});

  static const route = '/recievewallet';

  @override
  State<StatefulWidget> createState() {
    return ReceiveWalletState();
  }
}

class ReceiveWalletState extends State<ReceiveWallet> {
  String _brightnessLevel = "Unkown brigtness level";

  GlobalKey<ScaffoldState> _globalKey;

  GlobalKey _keyQrShare = GlobalKey();

  dynamic result;

  GetWalletMethod _method = GetWalletMethod();
  String name = 'username';
  String wallet = 'wallet address';

  @override
  void initState() {
    //print(widget.homeM.userData);
    name = widget.keyring.keyPairs[0].name;
    wallet = widget.keyring.keyPairs[0].address;
    _globalKey = GlobalKey<ScaffoldState>();
    AppServices.noInternetConnection(_globalKey);
    _method.platformChecker(context);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: ReceiveWalletBody(
            keyQrShare: _keyQrShare,
            globalKey: _globalKey,
            // homeM: widget.homeM,
            method: _method,
            name: name,
            wallet: wallet,
          )),
    );
  }
}
