import 'package:wallet_apps/index.dart';

class Menu extends StatefulWidget {
  final Map<String, dynamic> _userData;


  Menu(this._userData, );

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
 

  MenuModel _menuModel = MenuModel();

  LocalAuthentication _localAuth;

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
    //AppServices.noInternetConnection(_menuModel.globalKey);
  
    readBio();
    checkAvailableBio();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

 
  void checkAvailableBio() async {
    await StorageServices.fetchData('biometric').then((value) {
      if (value != null) {
        if (value['bio'] == true) {
          setState(() {
            _menuModel.switchBio = value['bio'];
          });
        }
      }
    });
  }

  void readBio() async {
    await StorageServices.readSaveBio().then((value) {
      setState(() {
        _menuModel.switchBio = value;
      });
    });
  }

  void switchBiometric(bool switchValue) async {
    //print(switchValue);

    // setState(() {
    //   _menuModel.switchBio = switchValue;
    // });
    _localAuth = LocalAuthentication();

    await _localAuth.canCheckBiometrics.then((value) async {
      if (value == false) {
        snackBar(_menuModel.globalKey, "Your device doesn't have finger print");
      } else {
        if (switchValue) {
          await authenticateBiometric(_localAuth).then((values) async {
            //print('value 1: $values');
            if (_menuModel.authenticated) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.saveBio(_menuModel.switchBio);
            }
          });
        } else {
          await authenticateBiometric(_localAuth).then((values) async {
            if (_menuModel.authenticated) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.removeKey('bio');
            }
          });
        }
      }
    });

  }

  Future<bool> authenticateBiometric(LocalAuthentication _localAuth) async {
    try {
      // Trigger Authentication By Finger Print
      _menuModel.authenticated = await _localAuth.authenticateWithBiometrics(
          localizedReason: '', useErrorDialogs: true, stickyAuth: true);
    } on PlatformException catch (e) {}
    return _menuModel.authenticated;
  }

  /* ----------------------Side Bar -------------------------*/

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
            ))),
      ),
    );
  }
}
