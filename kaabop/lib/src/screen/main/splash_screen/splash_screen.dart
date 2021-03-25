import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/route_animation.dart';


class MySplashScreen extends StatefulWidget {
  

  

  static const route = '/splash';
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

  Future<void> getCurrentAccount() async {
    await Future.delayed(const Duration(seconds: 1), () {
      final List<KeyPairData> ls = ApiProvider.keyring.keyPairs.toList();

      if (ls.isEmpty) {
        Navigator.pushReplacement(
            context, RouteAnimation(enterPage: Welcome()));
      } else {
        checkBiometric();
      }
    });
  }

  Future<void> checkBiometric() async {
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
      duration: const Duration(milliseconds: 200),
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

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: hexaCodeToColor(AppColors.bgdColor),
      body: Align(
        child: FadeTransition(
          opacity: animation,
          child: Image.asset(
            'assets/bitriel_splash.png',
            width: 350,
            height: 350,
          ),
        ),
      ),
    );
  }
}
