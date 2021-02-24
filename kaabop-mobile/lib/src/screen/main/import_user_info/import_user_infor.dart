import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/fmt.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_info_body.dart';

class ImportUserInfo extends StatefulWidget {
  final CreateAccModel importAccModel;

  static const route = '/importUserInfo';

  ImportUserInfo(this.importAccModel);

  @override
  State<StatefulWidget> createState() {
    return ImportUserInfoState();
  }
}

class ImportUserInfoState extends State<ImportUserInfo> {
  ModelUserInfo _userInfoM = ModelUserInfo();

  LocalAuthentication _localAuth;

  MenuModel _menuModel = MenuModel();

  @override
  void initState() {
    // // print(widget.importAccModel.mnemonicList);
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
    // print('subscribe');
    final channel = await widget.importAccModel.sdk.api.account
        .subscribeBalance(widget.importAccModel.keyring.current.address, (res) {
      setState(() {
        widget.importAccModel.balance = res;
        widget.importAccModel.nativeBalance =
            Fmt.balance(widget.importAccModel.balance.freeBalance, 18);
        // print(widget.importAccModel.nativeBalance);
      });
    });
    setState(() {
      widget.importAccModel.msgChannel = channel;
      // print('Channel $channel');
    });
  }

  Future<void> _importFromMnemonic() async {
    // print(" firstName ${_userInfoM.controlFirstName.text}");
    // print(" Password ${_userInfoM.confirmPasswordCon.text}");

    try {
      final json = await widget.importAccModel.sdk.api.keyring.importAccount(
        widget.importAccModel.keyring,
        keyType: KeyType.mnemonic,
        key: widget.importAccModel.mnemonic,
        name: _userInfoM.userNameCon.text,
        password: _userInfoM.confirmPasswordCon.text,
      );
      // print("My json $json");

      final acc = await widget.importAccModel.sdk.api.keyring.addAccount(
        widget.importAccModel.keyring,
        keyType: KeyType.mnemonic,
        acc: json,
        password: _userInfoM.confirmPasswordCon.text,
      );

      // print("My account name ${acc.name}");
      if (acc != null) {
        widget.importAccModel.mnemonic = '';
        _subscribeBalance();

        await dialogSuccess(context, Text("You haved imported successfully"),
            Text('Congratulation'),
            action: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, Home.route, ModalRoute.withName('/'));
                },
                child: Text('Continue')));
      }
    } catch (e) {
      // print(e.toString());
      await dialog(
        context,
        Text("Invalid mnemonic"),
        Text('Message'),
      );
      Navigator.pop(context);
    }
  }

  void switchBiometric(bool switchValue) async {
    _localAuth = LocalAuthentication();

    await _localAuth.canCheckBiometrics.then((value) async {
      if (value == false) {
        snackBar(_menuModel.globalKey, "Your device doesn't have finger print");
      } else {
        if (switchValue) {
          await authenticateBiometric(_localAuth).then((values) async {
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
  void changeGender(String gender) async {}

  void onSubmit() async {
    if (_userInfoM.userNameNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.passwordNode);
    } else if (_userInfoM.passwordNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.confirmPasswordNode);
    } else {
      FocusScope.of(context).unfocus();
      validateAll();
      if (_userInfoM.enable) await submitProfile();
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
        _userInfoM.responseFirstname += "username";
    }
    return _userInfoM.responseFirstname;
  }

  String validatePassword(String value) {
    if (_userInfoM.passwordNode.hasFocus) {
      _userInfoM.responseMidname = instanceValidate.validatePin(value);
      if (_userInfoM.responseMidname == null) return null;
      //  else
      // _userInfoM.responseMidname += "password";
    }
    return _userInfoM.responseMidname;
  }

  String validateConfirmPassword(String value) {
    if (_userInfoM.confirmPasswordNode.hasFocus) {
      if (value.isEmpty) {
        return 'Please fill in confirm pin';
      } else if (_userInfoM.confirmPasswordCon.text !=
          _userInfoM.passwordCon.text) {
        return 'Pin does not matched';
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
      }
    } else if (_userInfoM.enable)
      setState(() {
        enableButton(false);
      });
  }

  // Submit Profile User
  Future<void> submitProfile() async {
    // Show Loading Process
    dialogLoading(context);

    await _importFromMnemonic();
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
              menuModel: _menuModel,
              item: item)),
    );
  }
}
