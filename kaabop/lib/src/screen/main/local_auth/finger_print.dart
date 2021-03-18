import 'package:local_auth/local_auth.dart';
import 'package:wallet_apps/index.dart';

class FingerPrint extends StatefulWidget {
  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  final localAuth = LocalAuthentication();

  bool enableText = false;

  String authorNot = 'Not Authenticate';

  GlobalKey<ScaffoldState> globalkey;

  @override
  void initState() {
    globalkey = GlobalKey<ScaffoldState>();
    authenticate();
    super.initState();
  }

  Future<void> authenticate() async {
    bool authenticate = false;

    try {
      authenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: '', stickyAuth: true);

      if (authenticate) {
        Navigator.pushReplacementNamed(context, Home.route);
      }
    } on SocketException catch (e) {
      await Future.delayed(const Duration(milliseconds: 300), () {});
      AppServices.openSnackBar(globalkey, e.message);
    } catch (e) {
      await dialog(context, Text("${e.message}", textAlign: TextAlign.center),
          const Text("Message"));
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
              const MyText(
                  text: 'Bitriel Locked',
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold),
              const SizedBox(
                height: 40.0,
              ),
              SvgPicture.asset("assets/undraw_secure.svg",
                  width: 200, height: 200),
              const SizedBox(
                height: 40.0,
              ),
              const MyText(top: 19.0, text: 'Authentication Required'),
            ],
          ),
        ),
      ),
    );
  }
}
