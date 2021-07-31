import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:bip39/bip39.dart' as bip39;

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

  // ignore: avoid_positional_boolean_parameters
  Future<void> switchBiometric(bool switchValue) async {
    // _localAuth = LocalAuthentication();

    // await _localAuth.canCheckBiometrics.then((value) async {
    //   if (value == false) {
    //     snackBar(context, "Your device doesn't have finger print");
    //   } else {
    //     if (switchValue) {
    //       await authenticateBiometric(_localAuth).then((values) async {
    //         if (_menuModel.authenticated) {
    //           setState(() {
    //             _menuModel.switchBio = switchValue;
    //           });
    //           await StorageServices.saveBio(_menuModel.switchBio);
    //         }
    //       });
    //     } else {
    //       await authenticateBiometric(_localAuth).then((values) async {
    //         if (_menuModel.authenticated) {
    //           setState(() {
    //             _menuModel.switchBio = switchValue;
    //           });
    //           await StorageServices.removeKey('bio');
    //         }
    //       });
    //     }
    //   }
    // });

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: MyText(
              text: "Oops",
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text("This feature has not implemented yet!",
                textAlign: TextAlign.center),
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
          final resPk = await ApiProvider().getPrivateKey(widget.passPhrase);
          if (resPk != null) {
            ContractProvider().extractAddress(resPk);
            final res = await ApiProvider.keyring.store.encryptPrivateKey(
              resPk,
              _userInfoM.confirmPasswordCon.text,
            );

            if (res != null) {
              await StorageServices().writeSecure('private', res);
            }
          }
          Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

          Provider.of<ApiProvider>(context, listen: false).connectPolNon();
          Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
          Provider.of<ContractProvider>(context, listen: false).getBscBalance();
          Provider.of<ContractProvider>(context, listen: false)
              .getBscV2Balance();

          isKgoContain();
          await addBtcWallet();

          Provider.of<MarketProvider>(context, listen: false)
              .fetchTokenMarketPrice(context);

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
          await successDialog(context, "created your account.");
        },
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text('Opps'),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(e.message.toString()),
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
  // Future<void> isDotContain() async {
  //   // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('DOT');
  //   // Provider.of<ApiProvider>(context, listen: false).isDotContain();
  //   Provider.of<ApiProvider>(context, listen: false).connectPolNon();
  //   // await StorageServices.readBool('DOT').then((value) {
  //   //   if (value) {
  //   //     Provider.of<WalletProvider>(context, listen: false)
  //   //         .addTokenSymbol('DOT');
  //   //     Provider.of<ApiProvider>(context, listen: false).isDotContain();
  //   //     Provider.of<ApiProvider>(context, listen: false).connectPolNon();
  //   //   }
  //   // });
  // }

  // Future<void> isBnbContain() async {
  //   Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BNB');
  //   Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
  //   // await StorageServices.readBool('BNB').then((value) {
  //   //   if (value) {

  //   //   }
  //   // });
  // }

  // Future<void> isBscContain() async {
  //   Provider.of<WalletProvider>(context, listen: false)
  //       .addTokenSymbol('SEL (BEP-20)');
  //   Provider.of<ContractProvider>(context, listen: false).getSymbol();
  //   Provider.of<ContractProvider>(context, listen: false)
  //       .getBscDecimal()
  //       .then((value) {
  //     Provider.of<ContractProvider>(context, listen: false).getBscBalance();
  //   });

  //   // await StorageServices.readBool('SEL').then((value) {
  //   //   if (value) {

  //   //   }
  //   // });
  // }

  Future<void> addBtcWallet() async {
    final seed = bip39.mnemonicToSeed(widget.passPhrase);
    final hdWallet = HDWallet.fromSeed(seed);

    final keyPair = ECPair.fromWIF(hdWallet.wif);
    final bech32Address = new P2WPKH(
            data: new PaymentData(pubkey: keyPair.publicKey), network: bitcoin)
        .data
        .address;

    await StorageServices.setData(bech32Address, 'bech32');

    final res = await ApiProvider.keyring.store
        .encryptPrivateKey(hdWallet.wif, _userInfoM.confirmPasswordCon.text);

    if (res != null) {
      await StorageServices().writeSecure('btcwif', res);
    }

    Provider.of<ApiProvider>(context, listen: false)
        .getBtcBalance(hdWallet.address);
    Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain');

    Provider.of<ApiProvider>(context, listen: false).setBtcAddr(bech32Address);
    Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
  }

  Future<void> isKgoContain() async {
    Provider.of<ContractProvider>(context, listen: false)
        .getKgoDecimal()
        .then((value) {
      Provider.of<ContractProvider>(context, listen: false).getKgoBalance();
    });
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
        ),
      ),
    );
  }
}
