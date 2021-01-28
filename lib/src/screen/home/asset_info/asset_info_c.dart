import 'package:flutter/material.dart';

import '../../../../index.dart';

class AssetInfoC {
  bool transferFrom = false;

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
      TextEditingController _recieverController,
      TextEditingController _amountController,
      TextEditingController _pinController,
      FocusNode _ownerNode,
      FocusNode _spenderNode,
      FocusNode _passNode,
      Function onChanged,
      Function onSubmit,
      Function submitApprove) {
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
              children: <Widget>[
                MyInputField(
                  labelText: 'Reciever Address',
                  controller: _recieverController,
                  focusNode: _ownerNode,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 16),
                MyInputField(
                  labelText: 'Amount',
                  controller: _amountController,
                  focusNode: _spenderNode,
                  inputType: TextInputType.number,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 16),
                MyInputField(
                  labelText: 'Pin',
                  controller: _pinController,
                  focusNode: _passNode,
                  obcureText: true,
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
                      submitApprove();
                    } //scanPayM.enable == false ? null : clickSend
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showtransferFrom(
      BuildContext context,
      TextEditingController _recieverController,
      TextEditingController _amountController,
      TextEditingController _pinController,
      FocusNode _ownerNode,
      FocusNode _spenderNode,
      FocusNode _passNode,
      Function onChanged,
      Function onSubmit,
      Function submitApprove) {
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
              children: <Widget>[
                MyInputField(
                  labelText: 'Reciever Address',
                  controller: _recieverController,
                  focusNode: _ownerNode,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 16),
                MyInputField(
                  labelText: 'Amount',
                  controller: _amountController,
                  focusNode: _spenderNode,
                  inputType: TextInputType.number,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                ),
                SizedBox(height: 16),
                MyInputField(
                  labelText: 'Pin',
                  controller: _pinController,
                  focusNode: _passNode,
                  obcureText: true,
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
                      submitApprove();
                    } //scanPayM.enable == false ? null : clickSend
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBalanceOf(
      BuildContext context,
      TextEditingController _recieverController,
      FocusNode _ownerNode,
      Function onChanged,
      Function onSubmit,
      Function submitBalanceOf) {
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
              children: <Widget>[
                MyInputField(
                  labelText: 'Address',
                  controller: _recieverController,
                  focusNode: _ownerNode,
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
                      submitBalanceOf();
                    } //scanPayM.enable == false ? null : clickSend
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void transferFrom(
  //     BuildContext context,
  //     TextEditingController _ownerController,
  //     TextEditingController _spenderController,
  //     FocusNode _ownerNode,
  //     FocusNode _spenderNode,
  //     Function onChanged,
  //     Function onSubmit) {
  //   showBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Padding(
  //         padding: MediaQuery.of(context).viewInsets,
  //         child: Container(
  //           padding: const EdgeInsets.all(25.0),
  //           height: MediaQuery.of(context).size.height / 2,
  //           color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
  //           child: Column(
  //             children: <Widget>[
  //               MyInputField(
  //                 labelText: 'Owner',
  //                 controller: _ownerController,
  //                 focusNode: _ownerNode,
  //                 onChanged: onChanged,
  //                 onSubmit: onSubmit,
  //               ),
  //               SizedBox(height: 16),
  //               MyInputField(
  //                 labelText: 'Spender',
  //                 controller: _spenderController,
  //                 focusNode: _spenderNode,
  //                 onChanged: onChanged,
  //                 onSubmit: onSubmit,
  //               ),
  //               SizedBox(height: 25),
  //               MyFlatButton(
  //                   textButton: "Submit",
  //                   buttonColor: AppColors.secondary,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: size18,
  //                   edgeMargin: EdgeInsets.only(top: 40, left: 66, right: 66),
  //                   hasShadow: true,
  //                   action: () {} //scanPayM.enable == false ? null : clickSend
  //                   ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
