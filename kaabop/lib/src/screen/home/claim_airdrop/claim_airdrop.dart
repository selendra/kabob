import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/components/component.dart';

import '../../../../index.dart';

class ClaimAirDrop extends StatefulWidget {
  @override
  _ClaimAirDropState createState() => _ClaimAirDropState();
}

class _ClaimAirDropState extends State<ClaimAirDrop> {
  TextEditingController _emailController;

  TextEditingController _phoneController;

  TextEditingController _walletController;

  TextEditingController _socialController;

  FocusNode _emailFocusNode;

  FocusNode _phoneFocusNode;

  FocusNode _walletFocusNode;

  FocusNode _socialFocusNode;

  final airdropKey = GlobalKey<FormState>();

  FlareControls flareController = FlareControls();

  bool _enableButton = false;
  bool _submitted = false;

  // ignore: unnecessary_raw_strings

// your spreadsheet id
  static const _spreadsheetId = AppConfig.spreedSheetId;

  bool validateEmail(String value) {
    const Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern.toString());
    // ignore: avoid_bool_literals_in_conditional_expressions
    return (!regex.hasMatch(value)) ? false : true;
  }

  String onChangedEmail(String value) {
    if (_emailFocusNode.hasFocus && _phoneController.text.isNotEmpty) {
      if (airdropKey.currentState.validate()) {
        setState(() {
          _enableButton = true;
        });
      } else {
        setState(() {
          _enableButton = false;
        });
      }
    }
    return null;
  }

  String onChanged(String value) {
    if (_emailFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
    } else {
      if (airdropKey.currentState.validate()) {
        setState(() {
          _enableButton = true;
        });
      } else {
        setState(() {
          _enableButton = false;
        });
      }
    }

    return null;
  }

  String validateEmailField(String value) {
    if (value.isEmpty || validateEmail(value) == false) {
      return 'Please fill in valid email address';
    }
    return null;
  }

  void onSubmit() {
    if (_emailFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
    } else if (_emailFocusNode.hasFocus && _phoneController.text.isNotEmpty) {
      if (airdropKey.currentState.validate()) {
        setState(() {
          _enableButton = true;
        });
      } else {
        setState(() {
          _enableButton = false;
        });
      }
    } else {
      if (airdropKey.currentState.validate()) {
        setState(() {
          _enableButton = true;
        });
      } else {
        setState(() {
          _enableButton = false;
        });
      }
    }
  }

  Future<void> submitForm() async {
    dialogLoading(context);
    final gsheets = GSheets(AppConfig.credentials);
    // fetch spreadsheet by its id
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    // get worksheet by its title

    final sheet = ss.worksheetById(0);

    try {
      await sheet.values.appendRow([
        _emailController.text,
        _phoneController.text,
        _walletController.text,
        _socialController.text ?? ''
      ]);

      enableAnimation();
    } catch (e) {
      Navigator.pop(context);
      await dialog(
        context,
        const Text('Something went wrong. Try again.'),
        const Text('Opps'),
      );
    }
  }

  Future<void> enableAnimation() async {
    Navigator.pop(context);
    flareController.play('Checkmark');

    setState(() {
      _submitted = true;
    });
    await StorageServices.setUserID('claim', 'claim');
    Provider.of<ContractProvider>(context, listen: false).getBscBalance();
    Provider.of<ContractProvider>(context, listen: false).getBnbBalance();

    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _walletController = TextEditingController();
    _socialController = TextEditingController();

    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _walletFocusNode = FocusNode();
    _socialFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _walletController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _walletController.text = Provider.of<ContractProvider>(context).ethAdd;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                MyAppBar(
                  title: 'Claim Airdrop',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Form(
                    key: airdropKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              child: Image.asset(
                                'assets/bep20.png',
                                height: 230,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          MyInputField(
                            pBottom: 24,
                            labelText:
                                "Email (by submitting will get +5 \$SEL)",
                            inputType: TextInputType.emailAddress,
                            textInputFormatter: [
                              LengthLimitingTextInputFormatter(
                                TextField.noMaxLength,
                              ),
                            ],
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            validateField: validateEmailField,
                            onChanged: onChangedEmail,
                            onSubmit: onSubmit,
                          ),
                          MyInputField(
                            pBottom: 24,
                            labelText:
                                "Phone Number (by submitting will get +5 \$SEL)",
                            textInputFormatter: [
                              LengthLimitingTextInputFormatter(
                                TextField.noMaxLength,
                              ),
                            ],
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            inputType: TextInputType.number,
                            validateField: (value) => value.isEmpty
                                ? 'Please fill in phone number'
                                : null,
                            onChanged: onChanged,
                            onSubmit: onSubmit,
                          ),
                          MyInputField(
                            pBottom: 8,
                            labelText:
                                "Wallet Address (0xe0e5c149b9cdf9d2279b6ddfda9bc0a4a975285c)",
                            textInputFormatter: [
                              LengthLimitingTextInputFormatter(
                                TextField.noMaxLength,
                              ),
                            ],
                            controller: _walletController,
                            focusNode: _walletFocusNode,
                            validateField: (value) => value.isEmpty
                                ? 'Please fill in wallet address'
                                : null,
                            onChanged: onChanged,
                            onSubmit: onSubmit,
                          ),
                          const MyText(
                            text:
                                'Get Wallet (each address will get 100 \$SEL)',
                            textAlign: TextAlign.left,
                            left: 16.0,
                            right: 16.0,
                            fontSize: 16.0,
                          ),
                          MyInputField(
                            pTop: 24.0,
                            pBottom: 8,
                            labelText: "Social Link (optional)",
                            textInputFormatter: [
                              LengthLimitingTextInputFormatter(
                                TextField.noMaxLength,
                              ),
                            ],
                            controller: _socialController,
                            focusNode: _socialFocusNode,
                            onChanged: onChanged,
                            onSubmit: onSubmit,
                          ),
                          const MyText(
                            text:
                                'Notes: shared link of (twitter,linkedin,facebook) +5 \$SEL each, YouTube video at least 30 seconds +50 \$SEL, per each approved video.',
                            textAlign: TextAlign.start,
                            left: 16.0,
                            right: 16.0,
                            fontSize: 16.0,
                          ),
                          const SizedBox(height: 20),
                          MyFlatButton(
                            textButton: "Claim Airdrop",
                            edgeMargin: const EdgeInsets.only(
                              top: 40,
                              left: 66,
                              right: 66,
                            ),
                            hasShadow: true,
                            action: _enableButton ? submitForm : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_submitted == false)
              Container()
            else
              BackdropFilter(
                // Fill Blur Background
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: CustomAnimation.flareAnimation(
                        flareController,
                        "assets/animation/check.flr",
                        "Checkmark",
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
