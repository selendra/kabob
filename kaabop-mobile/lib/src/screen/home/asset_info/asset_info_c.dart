import 'package:flutter/material.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';

import '../../../../index.dart';

class AssetInfoC {
  bool transferFrom = false;

  void showAllowance(
    BuildContext context,
    GlobalKey<FormState> _allowanceKey,
    TextEditingController _ownerController,
    TextEditingController _spenderController,
    FocusNode _ownerNode,
    FocusNode _spenderNode,
    Function onChangedAllow,
    Function onSubmit,
    Function submit,
    //GlobalKey<FormState> allowanceKeyForm,
  ) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _allowanceKey,
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
                    onChanged: onChangedAllow,
                    onSubmit: onSubmit,
                    validateField: (value) =>
                        value.isEmpty ? 'Owner is empty' : null,
                  ),
                  SizedBox(height: 16),
                  MyInputField(
                    labelText: 'Spender',
                    controller: _spenderController,
                    focusNode: _spenderNode,
                    onChanged: onChangedAllow,
                    onSubmit: onSubmit,
                    validateField: (value) =>
                        value.isEmpty ? 'Please fill in spender address' : null,
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
          ),
        );
      },
    );
  }

  void showRecieved(
    BuildContext context,
    CreateAccModel sdkModel,

    //GlobalKey<FormState> allowanceKeyForm,
  ) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 16.0),
            color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
            child: ReceiveWalletBody(
              name: sdkModel.userModel.username,
              wallet: sdkModel.userModel.address,
            ),
          ),
        );
      },
    );
  }

  void showApprove(
      BuildContext context,
      GlobalKey<FormState> _approveKey,
      TextEditingController _recieverController,
      TextEditingController _amountController,
      TextEditingController _pinController,
      FocusNode _ownerNode,
      FocusNode _spenderNode,
      FocusNode _passNode,
      Function onChangedApprove,
      Function onSubmit,
      Function submitApprove) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _approveKey,
            child: Container(
              padding: const EdgeInsets.all(25.0),
              height: MediaQuery.of(context).size.height / 1.5,
              color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40.0),
                  MyInputField(
                    labelText: 'Reciever Address',
                    controller: _recieverController,
                    focusNode: _ownerNode,
                    onChanged: onChangedApprove,
                    onSubmit: onSubmit,
                    validateField: (value) => value.isEmpty
                        ? 'Please fill in Reciever address'
                        : null,
                  ),
                  SizedBox(height: 16),
                  MyInputField(
                    labelText: 'Amount',
                    controller: _amountController,
                    focusNode: _spenderNode,
                    inputType: TextInputType.number,
                    onChanged: onChangedApprove,
                    onSubmit: onSubmit,
                    validateField: (value) =>
                        value.isEmpty ? 'Please fill in Amount' : null,
                  ),
                  SizedBox(height: 16),
                  MyInputField(
                    labelText: 'Pin',
                    controller: _pinController,
                    focusNode: _passNode,
                    obcureText: true,
                    onChanged: onChangedApprove,
                    onSubmit: onSubmit,
                    validateField: (value) =>
                        value.isEmpty || value.length <= 4 || value.length >= 6
                            ? 'Please fill in pin'
                            : null,
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
          ),
        );
      },
    );
  }

  void showtransferFrom(
      BuildContext context,
      GlobalKey<FormState> _transferFromKey,
      TextEditingController _fromController,
      TextEditingController _recieverController,
      TextEditingController _amountController,
      TextEditingController _pinController,
      FocusNode _fromNode,
      FocusNode _ownerNode,
      FocusNode _spenderNode,
      FocusNode _passNode,
      Function onChangedTransferFrom,
      Function onSubmit,
      Function submitApprove) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Form(
              key: _transferFromKey,
              child: Container(
                padding: const EdgeInsets.all(25.0),
                height: MediaQuery.of(context).size.height / 1.5,
                color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    MyInputField(
                      labelText: 'From Address',
                      controller: _fromController,
                      focusNode: _fromNode,
                      onChanged: onChangedTransferFrom,
                      onSubmit: onSubmit,
                      validateField: (value) =>
                          value.isEmpty ? 'Please fill in from address' : null,
                    ),
                    SizedBox(height: 16),
                    MyInputField(
                      labelText: 'Reciever Address',
                      controller: _recieverController,
                      focusNode: _ownerNode,
                      onChanged: onChangedTransferFrom,
                      onSubmit: onSubmit,
                      validateField: (value) => value.isEmpty
                          ? 'Please fill in Reciever Address'
                          : null,
                    ),
                    SizedBox(height: 16),
                    MyInputField(
                      labelText: 'Amount',
                      controller: _amountController,
                      focusNode: _spenderNode,
                      inputType: TextInputType.number,
                      onChanged: onChangedTransferFrom,
                      onSubmit: onSubmit,
                      validateField: (value) =>
                          value.isEmpty ? 'Please fill in Amount' : null,
                    ),
                    SizedBox(height: 16),
                    MyInputField(
                      labelText: 'Pin',
                      controller: _pinController,
                      focusNode: _passNode,
                      obcureText: true,
                      onChanged: onChangedTransferFrom,
                      onSubmit: onSubmit,
                      validateField: (value) =>
                          value.isEmpty ? 'Please fill in Pin' : null,
                    ),
                    SizedBox(height: 15),
                    MyFlatButton(
                        textButton: "Submit",
                        buttonColor: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: size18,
                        edgeMargin:
                            EdgeInsets.only(top: 40, left: 66, right: 66),
                        hasShadow: true,
                        action: () {
                          submitApprove();
                        } //scanPayM.enable == false ? null : clickSend
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showBalanceOf(
      BuildContext context,
      GlobalKey<FormState> _balanceofKey,
      TextEditingController _recieverController,
      FocusNode _ownerNode,
      Function onChangedBalanceOf,
      Function onSubmit,
      Function submitBalanceOf) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _balanceofKey,
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
                    onChanged: onChangedBalanceOf,
                    onSubmit: onSubmit,
                    validateField: (value) =>
                        value.isEmpty || value.length <= 4 || value.length >= 6
                            ? 'Please fill in address'
                            : null,
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
