import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/theme/color.dart';
import '../../../../index.dart';

class AccountC {
  void showChangePin(
      BuildContext context,
      GlobalKey<FormState> _changePinKey,
      TextEditingController _oldPinController,
      TextEditingController _newPinController,
      FocusNode _oldNode,
      FocusNode _newNode,
      Function onChanged,
      Function onSubmit,
      Function submitChangePin) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
        return Container(
          padding: const EdgeInsets.all(25.0),
          height: MediaQuery.of(context).size.height / 1.5,
          color: isDarkTheme
              ? Color(AppUtils.convertHexaColor(AppColors.darkBgd))
              : Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
          child: Form(
            key: _changePinKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyInputField(
                    labelText: 'Old Pin',
                    controller: _oldPinController,
                    focusNode: _oldNode,
                    obcureText: true,
                    validateField: (value) => value.isEmpty || value.length < 4
                        ? 'Please fill in old 4 digits pin'
                        : null,
                    textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                    onSubmit: onSubmit,
                  ),
                  const SizedBox(height: 16.0),
                  MyInputField(
                    labelText: 'New Pin',
                    controller: _newPinController,
                    focusNode: _newNode,
                    obcureText: true,
                    validateField: (value) => value.isEmpty || value.length < 6
                        ? 'Please fill in new 4 digits pin'
                        : null,
                    textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                    onSubmit: onSubmit,
                  ),
                  const SizedBox(height: 25),
                  MyFlatButton(
                    textButton: "Submit",
                    edgeMargin: const EdgeInsets.only(
                      top: 40,
                      left: 66,
                      right: 66,
                    ),
                    hasShadow: true,
                    action: () {
                      submitChangePin();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showBackup(
      BuildContext context,
      GlobalKey<FormState> _backupKey,
      TextEditingController _pinController,
      FocusNode _pinNode,
      String Function(String) onChanged,
      Function onSubmit,
      Function submitBackUpKey) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
        return Container(
          padding: const EdgeInsets.all(25.0),
          height: MediaQuery.of(context).size.height / 2,
          color: isDarkTheme
              ? Color(AppUtils.convertHexaColor(AppColors.darkBgd))
              : Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
          child: Form(
            key: _backupKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyInputField(
                    labelText: 'Pin',
                    controller: _pinController,
                    focusNode: _pinNode,
                    onChanged: onChanged,
                    obcureText: true,
                    validateField: (value) => value.isEmpty || value.length < 4
                        ? 'Please fill in your 4 digits pin'
                        : null,
                    textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                    onSubmit: onSubmit,
                  ),
                  const SizedBox(height: 25),
                  MyFlatButton(
                    textButton: "Submit",
                    edgeMargin: const EdgeInsets.only(
                      top: 40,
                      left: 66,
                      right: 67,
                    ),
                    hasShadow: true,
                    action: () {
                      submitBackUpKey();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
