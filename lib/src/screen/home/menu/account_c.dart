import 'package:flutter/material.dart';
import 'package:wallet_apps/theme/color.dart';
import '../../../../index.dart';

class AccountC {
  void showChangePin(
      BuildContext context,
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
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            height: MediaQuery.of(context).size.height / 2,
            color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
            child: Column(
              children: [
                MyInputField(
                  labelText: 'Old Pin',
                  controller: _oldPinController,
                  focusNode: _oldNode,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 16.0),
                MyInputField(
                  labelText: 'New Pin',
                  controller: _newPinController,
                  focusNode: _newNode,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 25),
                MyFlatButton(
                    textButton: "Submit",
                    buttonColor: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: size18,
                    edgeMargin: EdgeInsets.only(top: 40, left: 66, right: 66),
                    hasShadow: true,
                    action: () {
                      submitChangePin();
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBackup(
      BuildContext context,
      TextEditingController _pinController,
      FocusNode _pinNode,
      Function onChanged,
      Function onSubmit,
      Function submitBackUpKey) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            height: MediaQuery.of(context).size.height / 2,
            color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
            child: Column(
              children: [
                MyInputField(
                  labelText: 'Pin',
                  controller: _pinController,
                  focusNode: _pinNode,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 25),
                MyFlatButton(
                    textButton: "Submit",
                    buttonColor: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: size18,
                    edgeMargin: EdgeInsets.only(top: 40, left: 66, right: 66),
                    hasShadow: true,
                    action: () {
                      submitBackUpKey();
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
