import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';

class ReceiveWallet extends StatefulWidget {
  final CreateAccModel createAccModel;

  const ReceiveWallet(this.createAccModel);

  static const route = '/recievewallet';

  @override
  State<StatefulWidget> createState() {
    return ReceiveWalletState();
  }
}

class ReceiveWalletState extends State<ReceiveWallet> {
  GlobalKey<ScaffoldState> _globalKey;
  final GlobalKey _keyQrShare = GlobalKey();


  final GetWalletMethod _method = GetWalletMethod();
  String name = 'username';
  String wallet = 'wallet address';

  @override
  void initState() {
    name = widget.createAccModel.keyring.keyPairs[0].name;
    wallet = widget.createAccModel.keyring.keyPairs[0].address;
    _globalKey = GlobalKey<ScaffoldState>();
    AppServices.noInternetConnection(_globalKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Consumer<ApiProvider>(
          builder: (context, value, child) {
            return ReceiveWalletBody(
              keyQrShare: _keyQrShare,
              globalKey: _globalKey,
              method: _method,
              name: value.accountM.name,
              wallet: value.accountM.address,
            );
          },
        ),
      ),
    );
  }
}
