import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart' as auth;
import 'package:wallet_apps/index.dart';

class Menu extends StatefulWidget {
  final Map<String, dynamic> _userData;

  const Menu(
    this._userData,
  );

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  final MenuModel _menuModel = MenuModel();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /* Login Inside Dialog */
  bool isDarkTheme = false;


  /* InitState */
  @override
  void initState() {
    _menuModel.globalKey = GlobalKey<ScaffoldState>();

    readBio();
    checkAvailableBio();
    checkPasscode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkPasscode() async {
    final res = await StorageServices().readSecure('passcode');

    if (res != null) {
      setState(() {
        _menuModel.switchPasscode = true;
      });
    }
  }

  Future<void> checkAvailableBio() async {
    await StorageServices.fetchData('biometric').then(
      (value) {
        if (value != null) {
          if (value['bio'] == true) {
            setState(() {
              _menuModel.switchBio = value['bio'] as bool;
            });
          }
        }
      },
    );
  }

  Future<void> readBio() async {
    await StorageServices.readSaveBio().then((value) {
      setState(() {
        _menuModel.switchBio = value;
      });
    });
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> switchBiometric(BuildContext context, bool switchValue) async {

    try{

      final canCheck = await AppServices().checkBiometrics(context);

      if (canCheck == false) {  
        snackBar(context, "Your device doesn't have finger print! Set up to enable this feature");
      } else {

        // Check New Enable Bio
        if (switchValue) {
          await authenticateBiometric().then((values) async {

            if (_menuModel.authenticated) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.saveBio(_menuModel.switchBio);
            }
          });
        } 
        // Check Disable Bio
        else {
          await authenticateBiometric().then((values) async {
            if (_menuModel.authenticated) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.removeKey('bio');
            }
          });
        }
      }
    } catch (e){
      print("error auth $e");
        
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: MyText(text: "Oops", fontWeight: FontWeight.w600,),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(e.toString(), textAlign: TextAlign.center),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> authenticateBiometric() async {
    try {
      // Trigger Authentication By Finger Print
      // ignore: deprecated_member_use
      _menuModel.authenticated = await _localAuth.authenticateWithBiometrics(
        localizedReason: 'Please complete the biometrics to proceed.',
        stickyAuth: true,
      );

      print("Authen ${_menuModel.authenticated}");

      // ignore: empty_catches
    } on PlatformException {}

    return _menuModel.authenticated;
  }

  /* ----------------------Side Bar -------------------------*/

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context,listen: false).isDark;
    return Drawer(
      key: _menuModel.globalKey,
      child: SafeArea(
        child: Container(
          color: isDarkTheme ?  hexaCodeToColor(AppColors.darkBgd) :  hexaCodeToColor(AppColors.bgdColor),
          child: SingleChildScrollView(
            child: MenuBody(
              userInfo: widget._userData,
              model: _menuModel,
              switchBio: switchBiometric,
             
            ),
          ),
        ),
      ),
    );
  }
}
