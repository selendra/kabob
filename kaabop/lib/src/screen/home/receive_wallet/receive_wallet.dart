import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';

class ReceiveWallet extends StatefulWidget {
  //static const route = '/recievewallet';

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
  String initialValue = 'SEL';

  @override
  void initState() {
    _globalKey = GlobalKey<ScaffoldState>();

    AppServices.noInternetConnection(_globalKey);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    name = Provider.of<ApiProvider>(context).accountM.name;
    wallet = Provider.of<ApiProvider>(context).accountM.address;
    super.didChangeDependencies();
  }

  void onChanged(String value) {
    setState(() {
      initialValue = value;
    });

    changedEthAdd(value);
  }

  void changedEthAdd(String value) {
    if (value != 'SEL' && value != 'DOT' && value != 'KMPI' && value != 'BTC') {
      setState(() {
        wallet = Provider.of<ContractProvider>(context, listen: false).ethAdd;
      });
    } else {
      if (value == 'BTC') {
        wallet = Provider.of<ApiProvider>(context, listen: false).btcAdd;
      } else {
        wallet =
            Provider.of<ApiProvider>(context, listen: false).accountM.address;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: ReceiveWalletBody(
          keyQrShare: _keyQrShare,
          globalKey: _globalKey,
          method: _method,
          name: name,
          wallet: wallet,
          initialValue: initialValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
