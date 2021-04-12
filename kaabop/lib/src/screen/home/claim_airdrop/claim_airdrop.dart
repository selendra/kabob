import 'package:flutter/material.dart';
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

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _phoneFocusNode = FocusNode();

  final FocusNode _walletFocusNode = FocusNode();

  final airdropKey = GlobalKey<FormState>();

  bool validateEmail(String value) {
    final Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern.toString());
    // ignore: avoid_bool_literals_in_conditional_expressions
    return (!regex.hasMatch(value)) ? false : true;
  }

  String onChangedEmail(String value) {
    if (value.isEmpty) {
      return 'Please fill in valid email address';
    } else {
      final isEmail = validateEmail(value);
      print(isEmail);
      if (!isEmail) {
        return 'Please fill in valid email address';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    _walletController.text = Provider.of<ContractProvider>(context).ethAdd;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
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
                      validateField: (value) => value.isEmpty
                          ? 'Please fill in receiver address'
                          : null,
                      onChanged: onChangedEmail,
                      onSubmit: () {},
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
                          ? 'Please fill in receiver address'
                          : null,
                      onChanged: null,
                      onSubmit: () {},
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
                          ? 'Please fill in receiver address'
                          : null,
                      onChanged: null,
                      onSubmit: () {},
                    ),
                    const SizedBox(height: 20),
                    const MyFlatButton(
                      textButton: "Claim Airdrop",
                      edgeMargin: EdgeInsets.only(
                        top: 40,
                        left: 66,
                        right: 66,
                      ),
                      hasShadow: true,
                      action: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
