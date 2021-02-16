import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
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
  MenuModel _menuModel = MenuModel();

  LocalAuthentication _localAuth;

  @override
  void initState() {
    AppServices.noInternetConnection(_userInfoM.globalKey);
    /* If Registering Account */
    // if (widget.passwords != null) getToken();
    super.initState();
  }

  void enableScreenshot() async {
    await FlutterScreenshotSwitcher.enableScreenshots();
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
      widget.accModel.balance = res;
      widget.accModel.mBalance =
          Fmt.balance(widget.accModel.balance.freeBalance, 18);
    });

    widget.accModel.msgChannel = channel;
  }

  Future<void> _balanceOf() async {
    try {
      final res = await widget.accModel.sdk.api.balanceOfByPartition(
        widget.accModel.keyring.keyPairs[0].address,
        widget.accModel.keyring.keyPairs[0].address,
        widget.accModel.contractModel.pHash,
      );

      setState(() {
        widget.accModel.contractModel.pBalance =
            BigInt.parse(res['output']).toString();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _contractSymbol() async {
    try {
      final res = await widget.accModel.sdk.api
          .contractSymbol(widget.accModel.keyring.keyPairs[0].address);
      if (res != null) {
        setState(() {
          widget.accModel.contractModel.pTokenSymbol = res[0];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getHashBySymbol() async {
    print('my symbol${widget.accModel.contractModel.pTokenSymbol}');

    try {
      final res = await widget.accModel.sdk.api.getHashBySymbol(
        widget.accModel.keyring.keyPairs[0].address,
        widget.accModel.contractModel.pTokenSymbol,
      );

      if (res != null) {
        widget.accModel.contractModel.pHash = res;

        print(res);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> _balanceOf(String from, String who) async {
  //   final res = await widget.accModel.sdk.api.balanceOf(from, who);
  //   if (res != null) {
  //     setState(() {
  //       widget.accModel.contractModel.pBalance = BigInt.parse(res['output']).toString();
  //     });
  //   }
  // }

  void switchBiometric(bool switchValue) async {
    print(switchValue);

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
            print('value 1: $values');
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
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {}
    return _menuModel.authenticated;
  }


  void popScreen() {
    Navigator.pop(context);
  }

  /* Change Select Gender */
  void changeGender(String gender) async {
    // _userInfoM.genderLabel = gender;
    // setState(() {
    //   if (gender == "Male")
    //     _userInfoM.gender = "M";
    //   else
    //     _userInfoM.gender = "F";
    // });
    // await Future.delayed(Duration(milliseconds: 100), () {
    //   setState(() {
    //     /* Unfocus All Field */
    //     if (_userInfoM.gender != null)
    //       enableButton(); /* Enable Button If User Set Gender */
    //     _userInfoM.nodeFirstName.unfocus();
    //     _userInfoM.nodeMidName.unfocus();
    //     _userInfoM.nodeLastName.unfocus();
    //   });
    // });
  }

  void onSubmit() {
    if (_userInfoM.userNameNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.passwordNode);
    } else if (_userInfoM.passwordNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.confirmPasswordNode);
    } else {
      FocusScope.of(context).unfocus();
      if (_userInfoM.enable) submitAcc();
    }
  }

  void onChanged(String value) {
    _userInfoM.formStateAddUserInfo.currentState.validate();
    validateAll();
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
    if (_userInfoM.passwordNode.hasFocus) {
      _userInfoM.responseMidname = instanceValidate.validatePin(value);
      if (_userInfoM.responseMidname == null)
        return null;
      else
        _userInfoM.responseMidname += "password";
    }
    return _userInfoM.responseMidname;
  }

  String validateConfirmPassword(String value) {
    if (_userInfoM.confirmPasswordNode.hasFocus) {
      _userInfoM.responseLastname = instanceValidate.validatePin(value);
      if (_userInfoM.responseLastname == null)
        return null;
      else
        _userInfoM.responseLastname += "confirm password";
    }
    return _userInfoM.responseLastname;
  }

  void validateAll() {
    if (_userInfoM.userNameCon.text.isNotEmpty &&
        _userInfoM.passwordCon.text.isNotEmpty &&
        _userInfoM.confirmPasswordCon.text.isNotEmpty) {
      if (_userInfoM.passwordCon.text == _userInfoM.confirmPasswordCon.text) {
        setState(() {
          enableButton(true);
        });
      } else {
        setState(() {
          enableButton(false);
        });
        validateConfirmPassword('not match');
      }
    } else if (_userInfoM.enable)
      setState(() {
        enableButton(false);
      });
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

        await _subscribeBalance();

        if (widget.accModel.keyring.keyPairs.length != 0) {
          await _contractSymbol();
          await _getHashBySymbol().then((value) async {
            await _balanceOf();
          });
        }

        // Close Loading Process
        Navigator.pop(context);
        enableScreenshot();
        await dialog(context, Text("You haved create account successfully"),
            Text('Congratulation'),
            action: FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Home.route, ModalRoute.withName('/'));
                },
                child: Text('Continue')));
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

  void enableButton(bool value) => _userInfoM.enable = value;

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
