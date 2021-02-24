import 'package:local_auth/local_auth.dart';
import 'package:wallet_apps/index.dart';

class FingerPrint extends StatefulWidget {
  FingerPrint();
  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  Widget screen = SlideBuilder();

  Backend _backend = Backend();

  final localAuth = LocalAuthentication();

  bool _hasFingerPrint = false;
  bool enableText = false;

  String authorNot = 'Not Authenticate';

  List<BiometricType> _availableBio = List<BiometricType>();

  GlobalKey<ScaffoldState> globalkey;

  @override
  void initState() {
    globalkey = GlobalKey<ScaffoldState>();
    authenticate();
    super.initState();
  }

  // Future<void> checkBioSupport() async {
  //   bool hasFingerPrint = false;
  //   try {
  //     hasFingerPrint = await localAuth.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     // print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _hasFingerPrint = hasFingerPrint;
  //   });
  // }

  // Future<void> getBioList() async {
  //   List<BiometricType> availableBio = List<BiometricType>();
  //   try {
  //     availableBio = await localAuth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     // print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _availableBio = availableBio;
  //   });
  // }

  Future<void> authenticate() async {
    bool authenticate = false;

    try {
      authenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: '', useErrorDialogs: true, stickyAuth: true);

      if (authenticate) {
        Navigator.pushReplacementNamed(context, Home.route);
      }
    } on SocketException catch (e) {
      await Future.delayed(Duration(milliseconds: 300), () {});
      AppServices.openSnackBar(globalkey, e.message);
    } catch (e) {
      await dialog(context, Text("${e.message}", textAlign: TextAlign.center),
          "Message");
    }
  }

  // Time Out Handler Method
  void timeCounter(Timer timer) async {
    // Assign Timer Number Counter To myNumCount Variable
    AppServices.myNumCount = timer.tick;

    // Cancel Timer When Rest Api Successfully
    if (_backend.response != null) timer.cancel();

    // Display TimeOut With SnackBar When Over 10 Second
    if (AppServices.myNumCount == 10) {
      Navigator.pop(context);
      await dialog(
          context,
          Text("Connection timeout", textAlign: TextAlign.center),
          Text("Mesage"));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SlideBuilder()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalkey,
        body: GestureDetector(
          onTap: () {
            setState(() {
              enableText = false;
            });
            authenticate();
          },
          child: BodyScaffold(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyText(
                    text: 'Kabob Locked',
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold),
                SvgPicture.asset("assets/finger_print.svg",
                    width: 300, height: 300),
                MyText(top: 19.0, text: 'Authentication Required'),
                // MyText(top: 19.0, text: 'Touch screen to trigger finger print')
              ],
            ),
          ),
        ));
  }
}
