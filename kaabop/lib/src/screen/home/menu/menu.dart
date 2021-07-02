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
  bool isProgress = false,
      isFetch = false,
      isTick = false,
      isSuccessPin = false,
      isHaveWallet = false;

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

  Future<bool> _checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _localAuth.canCheckBiometrics;
      print("Check bio $canCheckBiometrics");
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      print("Erorr $e");
      // canCheckBiometrics = false;
    }

    return canCheckBiometrics;
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> switchBiometric(BuildContext context, bool switchValue) async {
    // try{

    //   final canCheck = await _checkBiometrics();
    //   print("After check $canCheck");

    //   if (canCheck == false) {
    //     // snackBar(context, "Your device doesn't have finger print");

    //     await showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           shape:
    //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    //           title: Align(
    //             child: Text("Oops"),
    //           ),
    //           content: Padding(
    //             padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
    //             child: Text("Your device doesn't have finger print!", textAlign: TextAlign.center),
    //           ),
    //           actions: <Widget>[
    //             FlatButton(
    //               onPressed: () => Navigator.pop(context),
    //               child: const Text('Close'),
    //             ),
    //           ],
      //       );
      //     },
      //   );
      // } else {
      //   if (switchValue) {
      //     await authenticateBiometric().then((values) async {
      //       if (_menuModel.authenticated) {
      //         setState(() {
      //           _menuModel.switchBio = switchValue;
      //         });
      //         await StorageServices.saveBio(_menuModel.switchBio);
      //       }
      //     });
      //   } else {
      //     await authenticateBiometric().then((values) async {
      //       if (_menuModel.authenticated) {
      //         setState(() {
      //           _menuModel.switchBio = switchValue;
      //         });
      //         await StorageServices.removeKey('bio');
      //       }
      //     });
      //   }
      // }
    // } catch (e){
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text("Oops"),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text("This feature has not implemented yet!", textAlign: TextAlign.center),
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
    // }
  }

  Future<bool> authenticateBiometric() async {
    try {
      // Trigger Authentication By Finger Print
      // ignore: deprecated_member_use
      _menuModel.authenticated = await _localAuth.authenticateWithBiometrics(
        localizedReason: '',
        stickyAuth: true,
      );

      // ignore: empty_catches
    } on PlatformException {}

    return _menuModel.authenticated;
  }

  /* ----------------------Side Bar -------------------------*/

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: _menuModel.globalKey,
      child: SafeArea(
        child: Container(
          color: hexaCodeToColor(AppColors.bgdColor),
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
