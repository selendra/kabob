import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';
import 'package:wallet_apps/src/screen/main/create_user_info/user_info_body.dart';

class MyUserInfo extends StatefulWidget {
  final String passPhrase;
  const MyUserInfo(this.passPhrase);

  @override
  State<StatefulWidget> createState() {
    return MyUserInfoState();
  }
}

class MyUserInfoState extends State<MyUserInfo> {
  final ModelUserInfo _userInfoM = ModelUserInfo();

  final MenuModel _menuModel = MenuModel();

  LocalAuthentication _localAuth;

  @override
  void initState() {
    AppServices.noInternetConnection(_userInfoM.globalKey);
    /* If Registering Account */
    // if (widget.passwords != null) getToken();
    super.initState();
  }

  Future<void> enableScreenshot() async {
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

  // Future<void> _subscribeBalance() async {
  //   final walletProvider = Provider.of<WalletProvider>(context, listen: false);
  //   final channel = await widget.accModel.sdk.api.account
  //       .subscribeBalance(widget.accModel.keyring.current.address, (res) {
  //     widget.accModel.balance = res;
  //     widget.accModel.nativeBalance =
  //         Fmt.balance(widget.accModel.balance.freeBalance.toString(), 18);
  //     walletProvider.addAvaibleToken({
  //       'symbol': widget.accModel.nativeSymbol,
  //       'balance': widget.accModel.nativeBalance,
  //     });

  //     Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  //   });

  //   widget.accModel.msgChannel = channel;
  // }

  // ignore: avoid_positional_boolean_parameters
  Future<void> switchBiometric(bool switchValue) async {
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
          localizedReason: '', stickyAuth: true);
      // ignore: empty_catches
    } on PlatformException {}
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

  String onChanged(String value) {
    _userInfoM.formStateAddUserInfo.currentState.validate();
    validateAll();
    return null;
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
      if (value.isEmpty || value.length < 4) {
        return 'Please fill in 4-digits password';
      }
    }
    return _userInfoM.responseMidname;
  }

  String validateConfirmPassword(String value) {
    if (_userInfoM.confirmPasswordNode.hasFocus) {
      if (value.isEmpty || value.length < 4) {
        return 'Please fill in 4-digits confirm password';
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
    } else if (_userInfoM.enable) {
      setState(() {
        enableButton(false);
      });
    }
  }

  // Submit Profile User
  Future<void> submitAcc() async {
    // Show Loading Process
    dialogLoading(context);

    try {
      final json = await ApiProvider.sdk.api.keyring.importAccount(
        ApiProvider.keyring,
        keyType: KeyType.mnemonic,
        key: widget.passPhrase,
        name: _userInfoM.userNameCon.text,
        password: _userInfoM.confirmPasswordCon.text,
      );

      ApiProvider.sdk.api.keyring
          .addAccount(
        ApiProvider.keyring,
        keyType: KeyType.mnemonic,
        acc: json,
        password: _userInfoM.confirmPasswordCon.text,
      )
          .then(
        (value) async {
          await StorageServices.setData(
              _userInfoM.confirmPasswordCon.text, 'pass');

          Provider.of<ApiProvider>(context, listen: false).getChainDecimal();
          Provider.of<ApiProvider>(context, listen: false).getAddressIcon();
          Provider.of<ApiProvider>(context, listen: false).getCurrentAccount();
          Provider.of<WalletProvider>(context, listen: false).addAvaibleToken({
            'symbol':
                Provider.of<ApiProvider>(context, listen: false).nativeM.symbol,
            'balance': Provider.of<ApiProvider>(context, listen: false)
                    .nativeM
                    .balance ??
                '0',
          });

          // Close Loading Process
          Navigator.pop(context);
          enableScreenshot();
          await dialogSuccess(
            context,
            const Text("You haved imported successfully"),
            const Text('Congratulation'),
            // ignore: deprecated_member_use
            action: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, Home.route, ModalRoute.withName('/'));
              },
              child: const Text('Continue'),
            ),
          );
        },
      );
    } catch (e) {
      await dialog(context, Text(e.toString()), const Text("Message"));
    }
  }

  PopupMenuItem item(Map<String, dynamic> list) {
    return PopupMenuItem(
      value: list['gender'],
      child: Text("${list['gender']}"),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  // ignore: use_setters_to_change_properties
  void enableButton(bool value) => _userInfoM.enable = value;

  @override
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
