import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/fmt.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';
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
    var walletProvider = Provider.of<WalletProvider>(context,listen: false);
    final channel = await widget.accModel.sdk.api.account
        .subscribeBalance(widget.accModel.keyring.current.address, (res) {
      widget.accModel.balance = res;
      widget.accModel.nativeBalance =
          Fmt.balance(widget.accModel.balance.freeBalance, 18);
      walletProvider.addAvaibleToken({
        'symbol': widget.accModel.nativeSymbol,
        'balance': widget.accModel.nativeBalance,
      });
        
      Provider.of<WalletProvider>(context, listen: false).getPortfolio();

    });

    widget.accModel.msgChannel = channel;
  }

  void switchBiometric(bool switchValue) async {
    _localAuth = LocalAuthentication();

    await _localAuth.canCheckBiometrics.then((value) async {
      if (value == false) {
        // snackBar(_menuModel.globalKey, "Your device doesn't have finger print");
      } else {
        if (switchValue) {
          await authenticateBiometric(_localAuth).then((values) async {
            // print('value 1: $values');
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

  void popScreen() {
    Navigator.pop(context);
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
      if (value.isEmpty) {
        return 'Please fill in username';
      }
    }
    return _userInfoM.responseFirstname;
  }

  String validatePassword(String value) {
    if (_userInfoM.passwordNode.hasFocus) {
      if (value.isEmpty) {
        return 'Please fill in password';
      }
    }
    return _userInfoM.responseMidname;
  }

  String validateConfirmPassword(String value) {
    if (_userInfoM.confirmPasswordNode.hasFocus) {
      if (value.isEmpty) {
        return 'Please fill in confirm password';
      } else if (_userInfoM.confirmPasswordCon.text !=
          _userInfoM.passwordCon.text) {
        return 'Password does not matched';
      }
    }
    return null;
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

        // if (widget.accModel.keyring.keyPairs.length != 0) {
        //   await _contractSymbol();
        //   await _getHashBySymbol().then((value) async {
        //     await _balanceOf();
        //   });
        // }

        // Close Loading Process
        Navigator.pop(context);
        enableScreenshot();
        await dialogSuccess(context, Text("You haved imported successfully"),
            Text('Congratulation'),
            action: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
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
            validateFirstName: validateFirstName,
            validateMidName: validatePassword,
            validateLastName: validateConfirmPassword,
            submitProfile: submitAcc,
            popScreen: popScreen,
            switchBio: switchBiometric,
            item: item,
            model: _menuModel,
          )),
    );
  }
}
