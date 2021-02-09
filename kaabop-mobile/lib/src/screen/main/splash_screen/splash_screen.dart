import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
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

class MySplashScreenState extends State<MySplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  void getCurrentAccount() async {
    await Future.delayed(Duration(seconds: 4), () {
      final List<KeyPairData> ls = WalletProvider().keyring.keyPairs.toList();

      if (ls.isEmpty) {
        Navigator.pushReplacement(
            context, RouteAnimation(enterPage: Welcome()));
      } else {
        Navigator.pushReplacementNamed(context, Home.route);
      }
    });
  }

  // void checkBiometric() async {
  //   try {
  //     await StorageServices.fetchData('biometric').then((value) async {
  //       // value == null whenever User Not Yet Login Or User Logged Out
  //       await Future.delayed(Duration(seconds: 3), () async {
  //         if (value != null) {
  //           if (value['bio'] == true) {
  //             Navigator.pushReplacement(context,
  //                 MaterialPageRoute(builder: (context) => FingerPrint()));
  //           }
  //         } else {
  //           // _backend.response = await _getRequest.checkExpiredToken();
  //           // navigator();
  //           Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(builder: (context) => Welcome()),
  //               ModalRoute.withName('/'));
  //         }
  //       });
  //     });
  //   } on SocketException catch (e) {
  //     await dialog(context, Text("${e.message}", textAlign: TextAlign.center),
  //         "Message");
  //   } catch (e) {
  //     await dialog(context, Text("${e.message}", textAlign: TextAlign.center),
  //         "Message");
  //   }
  // }
  @override
  void initState() {
    getCurrentAccount();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: hexaCodeToColor(AppColors.bgdColor),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: 150.0,
          height: 150.0,
          child: SvgPicture.asset('assets/sld_logo.svg'),
        ),
      ),
    );
  }
}
