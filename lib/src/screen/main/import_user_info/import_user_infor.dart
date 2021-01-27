import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/main/create_user_info/user_info_body.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_info_body.dart';

class ImportUserInfo extends StatefulWidget {
  // final String mnemonic;
  // final Function importFromMnemonic;

  final CreateAccModel importAccModel;

  static const route = '/importUserInfo';

  // ImportUserInfo(this.mnemonic, this.importFromMnemonic);

  ImportUserInfo(this.importAccModel);

  @override
  State<StatefulWidget> createState() {
    return ImportUserInfoState();
  }
}

class ImportUserInfoState extends State<ImportUserInfo> {
  ModelUserInfo _userInfoM = ModelUserInfo();

  PostRequest _postRequest = PostRequest();

  Backend _backend = Backend();

  LocalAuthentication _localAuth;

  @override
  void initState() {
    print(widget.importAccModel.mnemonicList);
    AppServices.noInternetConnection(_userInfoM.globalKey);
    /* If Registering Account */
    // if (widget.passwords != null) getToken();
    super.initState();
  }

  @override
  void dispose() {
    /* Clear Everything When Pop Screen */
    _userInfoM.userNameCon.clear();
    _userInfoM.passwordCon.clear();
    _userInfoM.confirmPasswordCon.clear();
    _userInfoM.enable = false;
    super.dispose();
  }

  Future<void> _importFromMnemonic() async {
    try {
      final json = await widget.importAccModel.sdk.api.keyring.importAccount(
        widget.importAccModel.keyring,
        keyType: KeyType.mnemonic,
        key: widget.importAccModel.mnemonicList.join(" "),
        name: _userInfoM.controlFirstName.text,
        password: _userInfoM.confirmPasswordCon.text,
      );

      final acc = await widget.importAccModel.sdk.api.keyring.addAccount(
        widget.importAccModel.keyring,
        keyType: KeyType.mnemonic,
        acc: json,
        password: _userInfoM.confirmPasswordCon.text,
      );
      if (acc != null) {
        await dialog(context, Text("You haved imported successfully"),
            Text('Congratulation'),
            action: FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Home.route);
                },
                child: Text('Continue')));
      }
      print(acc.address);
      print(acc.name);
    } catch (e) {
       await dialog(context, Text("Invalid mnemonic"),
            Text('Message'),);
    }
  }

  void switchBiometric(bool value) async {
    _localAuth = LocalAuthentication();
    await _localAuth.canCheckBiometrics.then((value) async {
      if (value == false) {
        snackBar(_userInfoM.globalKey, "Your device doesn't have finger print");
      } else {
        //   try {
        //     if (value){
        //       await authenticateBiometric(_localAuth).then((values) async {
        //         if (_userInfoM.authenticated){
        //           _userInfoM.switchBio = value;
        //           await StorageServices.setData({'bio': values}, 'biometric');
        //         }
        //       });
        //     } else {
        //       await authenticateBiometric(_localAuth).then((values) async {
        //         if(values) {
        //           _menuModel.switchBio = value;
        //           await StorageServices.removeKey('biometric');
        //         }
        //       });
        //     }
        //     // // Reset Switcher
        //     setState(() { });
        //   } catch (e) {

        //   }
      }
    });
  }

  void popScreen() {
    Navigator.pop(context);
  }

  /* Change Select Gender */
  void changeGender(String gender) async {
    _userInfoM.genderLabel = gender;
    setState(() {
      if (gender == "Male")
        _userInfoM.gender = "M";
      else
        _userInfoM.gender = "F";
    });
    await Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        /* Unfocus All Field */
        if (_userInfoM.gender != null)
          enableButton(); /* Enable Button If User Set Gender */
        _userInfoM.nodeFirstName.unfocus();
        _userInfoM.nodeMidName.unfocus();
        _userInfoM.nodeLastName.unfocus();
      });
    });
  }

  void onSubmit() async {
    if (_userInfoM.userNameNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.passwordNode);
    } else if (_userInfoM.nodeMidName.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.confirmPasswordNode);
    } else {
      FocusScope.of(context).unfocus();
      enableButton();
      if (_userInfoM.enable) await _importFromMnemonic();
    }
  }

  void onChanged(String value) {
    _userInfoM.formStateAddUserInfo.currentState.validate();
  }

  String validateFirstName(String value) {
    if (_userInfoM.nodeFirstName.hasFocus) {
      _userInfoM.responseFirstname = instanceValidate.validateUserInfo(value);
      if (_userInfoM.responseFirstname == null)
        return null;
      else
        _userInfoM.responseFirstname += "user name";
    }
    return _userInfoM.responseFirstname;
  }

  String validatePassword(String value) {
    if (_userInfoM.nodeMidName.hasFocus) {
      _userInfoM.responseMidname = instanceValidate.validatePassword(value);
      if (_userInfoM.responseMidname == null)
        return null;
      else
        _userInfoM.responseMidname += "password";
    }
    return _userInfoM.responseMidname;
  }

  String validateConfirmPassword(String value) {
    if (_userInfoM.nodeLastName.hasFocus) {
      _userInfoM.responseLastname = instanceValidate.validatePassword(value);
      if (_userInfoM.responseLastname == null)
        return null;
      else
        _userInfoM.responseLastname += "confirm password";
    }
    return _userInfoM.responseLastname;
  }

  // Submit Profile User
  void submitProfile() async {
    // Show Loading Process
    dialogLoading(context);

    await Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });

  }

  PopupMenuItem item(Map<String, dynamic> list) {
    return PopupMenuItem(
      value: list['gender'],
      child: Text("${list['gender']}"),
    );
  }

  void enableButton() => _userInfoM.enable = true;

  Widget build(BuildContext context) {
    return Scaffold(
      key: _userInfoM.globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: ImportUserInfoBody(
          modelUserInfo: _userInfoM,
          onSubmit: onSubmit,
          onChanged: onChanged,
          changeGender: changeGender,
          validateFirstName: validateFirstName,
          validatepassword: validatePassword,
          validateConfirmPassword: validateConfirmPassword,
          submitProfile: submitProfile,
          popScreen: popScreen,
          switchBio: switchBiometric,
          item: item
        )
      ),
    );
  }
}
