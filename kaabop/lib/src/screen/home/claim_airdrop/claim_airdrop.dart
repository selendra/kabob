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
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _walletController = TextEditingController();

  final TextEditingController _socialController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _phoneFocusNode = FocusNode();

  final FocusNode _walletFocusNode = FocusNode();

  final FocusNode _socialFocusNode = FocusNode();

  final airdropKey = GlobalKey<FormState>();

  FlareControls flareController = FlareControls();

  bool _enableButton = false;
  bool _submitted = false;

  // ignore: unnecessary_raw_strings

// your spreadsheet id
  static const _spreadsheetId = AppConfig.spreedSheetId;

  void main() async {
    // init GSheets
    final gsheets = GSheets(AppConfig.credentials);
    // fetch spreadsheet by its id
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    // get worksheet by its title
    print(ss.sheets);

    final sheet = await ss.worksheetById(0);
    final secondRow = {
      'index': '5',
      'letter': 'f',
      'number': '6',
      'label': 'f6',
    };
    //await sheet.values.appendRow(['t','t','t','t']);
    await sheet.deleteRow(3);
  }

  bool validateEmail(String value) {
    final Pattern pattern =
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

    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  @override
  void initState() {
    super.initState();
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyInputField(
                          pBottom: 16,
                          labelText: "Email",
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
                          pBottom: 16,
                          labelText: "Phone Number",
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
                          pBottom: 16,
                          labelText: "Wallet Address",
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
                        MyInputField(
                          pBottom: 16,
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
