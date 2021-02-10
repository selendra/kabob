import 'package:wallet_apps/index.dart';

class Menu extends StatefulWidget {
  final Map<String, dynamic> _userData;

  Menu(this._userData);

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  ModelUserInfo _modelUserInfo = ModelUserInfo();

  MenuModel _menuModel = MenuModel();

  LocalAuthentication _localAuth;

  /* Login Inside Dialog */
  bool isProgress = false,
      isFetch = false,
      isTick = false,
      isSuccessPin = false,
      isHaveWallet = false;

  Backend _backend = Backend();

  /* InitState */
  @override
  void initState() {
    _menuModel.globalKey = GlobalKey<ScaffoldState>();
    AppServices.noInternetConnection(_menuModel.globalKey);
    setUserInfo();
    checkAvailableBio();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUserInfo() async {
    if (widget._userData.length != 0) {
      _modelUserInfo.userData = {
        "first_name": widget._userData['first_name'],
        "mid_name": widget._userData['mid_name'],
        "last_name": widget._userData['last_name'],
        "gender": widget._userData['gender'] == "M" ? "Male" : "Female",
        "label": "profile"
      };
      await StorageServices.fetchData("user_token").then((_response) {
        /* Fetch Token To Concete Authorization Update Profile User Info */
        _backend.mapData = _response;
      });
    }
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

  void switchBiometric(bool value) async {
    print(value);
    print(_menuModel.switchBio);
    _localAuth = LocalAuthentication();
    await _localAuth.canCheckBiometrics.then((value) async {
      if (value == false) {
        snackBar(_menuModel.globalKey, "Your device doesn't have finger print");
      } else {
        try {
          if (value) {
            await authenticateBiometric(_localAuth).then((values) async {
              if (_menuModel.authenticated) {
                _menuModel.switchBio = value;
                await StorageServices.setData({'bio': values}, 'biometric');
              }
            });
          } else {
            await authenticateBiometric(_localAuth).then((values) async {
              if (values) {
                _menuModel.switchBio = value;
                await StorageServices.removeKey('biometric');
              }
            });
          }
          // // Reset Switcher
          setState(() {});
        } catch (e) {}
      }
    });
  }

  Future<bool> authenticateBiometric(LocalAuthentication _localAuth) async {
    try {
      // Trigger Authentication By Finger Print
      _menuModel.authenticated = await _localAuth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {}
    return _menuModel.authenticated;
  }

  /* ----------------------Side Bar -------------------------*/

  Widget build(BuildContext context) {
    return Scaffold(
        key: _menuModel.globalKey,
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            // print("Tap");
          },
          child: Drawer(
            child: SafeArea(
              child: Container(
                  width: 305,
                  color: hexaCodeToColor(AppColors.bgdColor),
                  child: SingleChildScrollView(
                      child: MenuBody(
                    userInfo: widget._userData,
                    model: _menuModel,
                    switchBio: switchBiometric,
                  ))),
            ),
          ),
        ));
  }
}
