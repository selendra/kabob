import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/fmt.dart';
import 'package:wallet_apps/src/screen/main/create_user_info/user_info_body.dart';

class MyUserInfo extends StatefulWidget {
  CreateAccModel accModel;

  MyUserInfo(this.accModel);

  @override
  State<StatefulWidget> createState() {
    return MyUserInfoState();
  }
}

class MyUserInfoState extends State<MyUserInfo> {
  ModelUserInfo _userInfoM = ModelUserInfo();

  PostRequest _postRequest = PostRequest();

  Backend _backend = Backend();

  LocalAuthentication _localAuth;

  @override
  void initState() {
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

  Future<void> _subscribeBalance() async {
    print('subscribe');
    final channel = await widget.accModel.sdk.api.account
        .subscribeBalance(widget.accModel.keyring.current.address, (res) {
      setState(() {
        widget.accModel.balance = res;
        widget.accModel.mBalance =
            Fmt.balance(widget.accModel.balance.freeBalance, 18);
      });
    });
    setState(() {
      widget.accModel.msgChannel = channel;
      print('Channel $channel');
    });
  }

  Future<void> _balanceOf(String from, String who) async {
    final res = await widget.accModel.sdk.api.balanceOf(from, who);
    if (res != null) {
      setState(() {
        widget.accModel.kpiBalance = BigInt.parse(res['output']).toString();
      });
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

  void onSubmit() {
    if (_userInfoM.userNameNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.passwordNode);
    } else if (_userInfoM.nodeMidName.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.confirmPasswordNode);
    } else {
      FocusScope.of(context).unfocus();
      if (_userInfoM.enable) submitAcc();
    }
  }

  void onChanged(String value) {
    _userInfoM.formStateAddUserInfo.currentState.validate();
<<<<<<< HEAD
=======
    validateAll(); 
>>>>>>> daveat
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
  void submitAcc() async {
    // Show Loading Process
    dialogLoading(context);

    try {
      final json = await widget.accModel.sdk.api.keyring.importAccount(
        widget.accModel.keyring,
        keyType: KeyType.mnemonic,
        key: widget.accModel.mnemonic,
        name: _userInfoM.userNameCon.text,
        password: _userInfoM.confirmPasswordCon.text,
      );

      widget.accModel.sdk.api.keyring
          .addAccount(widget.accModel.keyring,
              keyType: KeyType.mnemonic,
              acc: json,
              password: _userInfoM.confirmPasswordCon.text)
          .then((value) async {
        await StorageServices.setData(
            _userInfoM.confirmPasswordCon.text, 'pass');

        // Close Loading Process
        Navigator.pop(context);

        _subscribeBalance();
        if (widget.accModel.keyring.keyPairs.length != 0) {
          _balanceOf(widget.accModel.keyring.keyPairs[0].address,
              widget.accModel.keyring.keyPairs[0].address);
        }

        await Future.delayed(Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
              context, Home.route, ModalRoute.withName('/'));
        });
      });
    } catch (e) {
      await dialog(context, Text(e.toString()), Text("Message"));
    }
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
          child: MyUserInfoBody(
              modelUserInfo: _userInfoM,
              onSubmit: onSubmit,
              onChanged: onChanged,
              changeGender: changeGender,
              validateFirstName: validateFirstName,
              validateMidName: validatePassword,
              validateLastName: validateConfirmPassword,
              submitProfile: submitAcc,
              popScreen: popScreen,
              switchBio: switchBiometric,
              item: item)),
    );
  }
}
