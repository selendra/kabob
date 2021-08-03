import 'package:wallet_apps/index.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomeState();
  }
}

class WelcomeState extends State<Welcome> {
  
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  bool status;
  int currentVersion;

  //var snackBar;

  @override
  void initState() {
    AppServices.noInternetConnection(globalKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: BodyScaffold(
        bottom: 0,
        child: WelcomeBody(),
      ),
    );
  }
}
