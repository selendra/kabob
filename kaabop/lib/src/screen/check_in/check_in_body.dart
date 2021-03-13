import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/models/checkin.m.dart';

class CheckInBody extends StatelessWidget {
  final CheckInModel checkinM;
  final Function onChanged;
  final Function getLocation;
  final Function clickSend;
  final Function qrRes;
  final Function resetAssetsDropDown;
  final List list;
  final PopupMenuItem Function(Map<String, dynamic>) item;

  CheckInBody(
    this.checkinM,
    this.onChanged,
    this.getLocation,
    this.clickSend,
    this.qrRes,
    this.resetAssetsDropDown,
    this.list,
    this.item,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: MyAppBar(
            title: "Attendant",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: checkinM.checkInKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyInputField(
                    pBottom: 16.0,
                    labelText: "Hash",
                    enableInput: false,
                    maxLine: 2,
                    prefixText: null,
                    textInputFormatter: [
                      LengthLimitingTextInputFormatter(TextField.noMaxLength)
                    ],
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    controller: checkinM.hashController,
                    focusNode: checkinM.hashNode,
                    validateField: (value) =>
                        value.isEmpty ? 'Please fill in hash' : null,
                    onChanged: onChanged,
                    onSubmit: null,
                  ),
                  GestureDetector(
                    onTap: () {
                      // getLocation();
                    },
                    child: MyInputField(
                      pBottom: 16.0,
                      enableInput: false,
                      labelText: "Current Location",
                      prefixText: null,
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(TextField.noMaxLength)
                      ],
                      inputType: TextInputType.text,
                      controller: checkinM.locationController,
                      focusNode: checkinM.locationNode,
                      maxLine: 2,
                      validateField: (value) =>
                          value.isEmpty ? 'Please fill in your location' : null,
                      onChanged: onChanged,
                      onSubmit: null,
                    ),
                  ),
                  Container(
                    /* Type of payment */
                    margin: EdgeInsets.only(
                      bottom: 16.0,
                      left: 16,
                      right: 16,
                    ),
                    child: customDropDown(
                        checkinM.status != null
                            ? checkinM.status
                            : "Asset name",
                        list,
                        checkinM,
                        resetAssetsDropDown,
                        item),

                    // child: customDropDown(label, list, _model, changeValue, item),
                  ),
                ],
              ),
            ),
          ),
        ),
        MyFlatButton(
          textButton: "Submit",
          buttonColor: AppColors.secondary,
          fontWeight: FontWeight.bold,
          fontSize: size18,
          edgeMargin: EdgeInsets.only(left: 66, right: 66),
          hasShadow: true,
          action: checkinM.isEnable ? clickSend : null,
        ),
      ],
    );
  }
}
