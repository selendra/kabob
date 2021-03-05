import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

class MySplashScreen extends StatefulWidget {
  CreateAccModel accModel;

  MySplashScreen(this.accModel);

  static const route = '/';
  @override
  State<StatefulWidget> createState() {
    return MySplashScreenState();
  }
}

class MySplashScreenState extends State<MySplashScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  AnimationController controller;
  Animation<double> animation;

  void getCurrentAccount() async {
    await Future.delayed(Duration(seconds: 1), () {
      final List<KeyPairData> ls = WalletProvider().keyring.keyPairs.toList();

      if (ls.isEmpty) {
        Navigator.pushReplacement(
            context, RouteAnimation(enterPage: Welcome()));
      } else {
        checkBiometric();
      }
    });
  }

  void checkBiometric() async {
    await StorageServices.readSaveBio().then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, RouteAnimation(enterPage: FingerPrint()));
      } else {
        Navigator.pushReplacementNamed(context, Home.route);
      }
    });
  }

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    animation = CurvedAnimation(
      curve: Curves.easeIn,
      parent: controller,
    );

    /*Perform faded animation to logo*/
    controller.forward().then(
      (value) {
        getCurrentAccount();
      },
    );

    super.initState();

    // Provider.of<WalletProvider>(context,listen: false).test();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: hexaCodeToColor(AppColors.bgdColor),
      body: Align(
        alignment: Alignment.center,
        child: FadeTransition(
          opacity: animation,
          child: Image.asset(
            'assets/kabob_logo.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
