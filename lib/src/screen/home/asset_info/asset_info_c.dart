import 'package:flutter/material.dart';

import '../../../../index.dart';

class AssetInfoC {
  void showAllowance(
    BuildContext context,
    TextEditingController _ownerController,
    TextEditingController _spenderController,
    FocusNode _ownerNode,
    FocusNode _spenderNode,
    Function onChanged,
    Function onSubmit,
    Function submit,
  ) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            height: MediaQuery.of(context).size.height / 2,
            color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
            child: Column(
              children: <Widget>[
                MyInputField(
                  labelText: 'Owner',
                  controller: _ownerController,
                  focusNode: _ownerNode,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 16),
                MyInputField(
                  labelText: 'Spender',
                  controller: _spenderController,
                  focusNode: _spenderNode,
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
                      submit();
                    } //scanPayM.enable == false ? null : clickSend
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showApprove(
      BuildContext context,
      TextEditingController _ownerController,
      TextEditingController _spenderController,
      FocusNode _ownerNode,
      FocusNode _spenderNode,
      Function onChanged,
      Function onSubmit) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            height: MediaQuery.of(context).size.height / 2,
            color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
            child: Column(
              children: <Widget>[
                MyInputField(
                  labelText: 'Owner',
                  controller: _ownerController,
                  focusNode: _ownerNode,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 16),
                MyInputField(
                  labelText: 'Spender',
                  controller: _spenderController,
                  focusNode: _spenderNode,
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
                    action: () {} //scanPayM.enable == false ? null : clickSend
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  void transferFrom(
      BuildContext context,
      TextEditingController _ownerController,
      TextEditingController _spenderController,
      FocusNode _ownerNode,
      FocusNode _spenderNode,
      Function onChanged,
      Function onSubmit) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            height: MediaQuery.of(context).size.height / 2,
            color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
            child: Column(
              children: <Widget>[
                MyInputField(
                  labelText: 'Owner',
                  controller: _ownerController,
                  focusNode: _ownerNode,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 16),
                MyInputField(
                  labelText: 'Spender',
                  controller: _spenderController,
                  focusNode: _spenderNode,
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
                    action: () {} //scanPayM.enable == false ? null : clickSend
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
