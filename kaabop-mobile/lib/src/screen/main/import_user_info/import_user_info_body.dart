import 'package:wallet_apps/index.dart';

class ImportUserInfoBody extends StatelessWidget {
  final ModelUserInfo modelUserInfo;
  final Function onSubmit;
  final Function onChanged;
  final Function changeGender;
  final Function validateFirstName;
  final Function validatepassword;
  final Function validateConfirmPassword;
  final Function submitProfile;
  final Function popScreen;
  final Function switchBio;
  final MenuModel menuModel;
  final PopupMenuItem Function(Map<String, dynamic>) item;

  ImportUserInfoBody(
      {this.modelUserInfo,
      this.onSubmit,
      this.onChanged,
      this.changeGender,
      this.validateFirstName,
      this.validatepassword,
      this.validateConfirmPassword,
      this.submitProfile,
      this.popScreen,
      this.switchBio,
      this.menuModel,
      this.item});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyAppBar(
          title: "User Information",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Container(
            margin: EdgeInsets.only(top: 16),
            child: Form(
              key: modelUserInfo.formStateAddUserInfo,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyInputField(
                      pBottom: 16.0,
                      labelText: "Username",
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(TextField.noMaxLength)
                      ],
                      controller: modelUserInfo.userNameCon,
                      focusNode: modelUserInfo.userNameNode,
                      validateField: validateFirstName,
                      textColor: "#FFFFFF",
                      onChanged: onChanged,
                      onSubmit: onSubmit),

                  // MyInputField(
                  //   pBottom: 16.0,
                  //   labelText: "Password",
                  //   textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                  //   controller: modelUserInfo.passwordCon,
                  //   focusNode: modelUserInfo.passwordNode,
                  //   validateField: validatepassword,
                  //   inputAction: TextInputAction.next,
                  //   textColor: "#FFFFFF",
                  //   onChanged: onChanged,
                  //   onSubmit: onSubmit
                  // ),

                  // MyInputField(
                  //   pBottom: 16.0,
                  //   labelText: "Confirm Password",
                  //   textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                  //   controller: modelUserInfo.confirmPasswordCon,
                  //   focusNode: modelUserInfo.confirmPasswordNode,
                  //   validateField: validateConfirmPassword,
                  //   inputAction: TextInputAction.done,
                  //   textColor: "#FFFFFF",
                  //   onChanged: onChanged,
                  //   onSubmit: onSubmit
                  // ),
                  Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextFormField(
                        key: this.key,
                        enabled: true,
                        focusNode: modelUserInfo.passwordNode,
                        validator: validatepassword,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: modelUserInfo.passwordCon,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                            color: hexaCodeToColor("#FFFFFF"), fontSize: 18.0),
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Pin",
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: modelUserInfo.passwordNode.hasFocus ||
                                      modelUserInfo.passwordCon.text != ""
                                  ? hexaCodeToColor("#FFFFF").withOpacity(0.3)
                                  : hexaCodeToColor(AppColors.textColor)),
                          prefixStyle: TextStyle(
                              color: hexaCodeToColor(AppColors.textColor),
                              fontSize: 18.0),
                          /* Prefix Text */
                          filled: true,
                          fillColor: hexaCodeToColor(AppColors.cardColor),
                          enabledBorder: myTextInputBorder(
                              modelUserInfo.passwordCon.text != ""
                                  ? hexaCodeToColor("#FFFFFF").withOpacity(0.3)
                                  : Colors.transparent),
                          /* Enable Border But Not Show Error */
                          border: errorOutline(),
                          /* Show Error And Red Border */
                          focusedBorder: myTextInputBorder(
                              hexaCodeToColor("#FFFFFF").withOpacity(0.3)),
                          /* Default Focuse Border Color*/
                          focusColor: hexaCodeToColor("#ffffff"),
                          /* Border Color When Focusing */
                          contentPadding: EdgeInsets.fromLTRB(
                              21, 23, 21, 23), // Default padding =
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(4)],
                        /* Limit Length Of Text Input */
                        onChanged: onChanged,
                        onFieldSubmitted: (value) {
                          onSubmit();
                        },
                      )),

                  Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: TextFormField(
                        key: this.key,
                        enabled: true,
                        controller: modelUserInfo.confirmPasswordCon,
                        focusNode: modelUserInfo.confirmPasswordNode,
                        validator: validateConfirmPassword,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            color: hexaCodeToColor("#FFFFFF"), fontSize: 18.0),
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Confirm Pin",
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: modelUserInfo
                                          .confirmPasswordNode.hasFocus ||
                                      modelUserInfo.passwordCon.text != ""
                                  ? hexaCodeToColor("#FFFFF").withOpacity(0.3)
                                  : hexaCodeToColor(AppColors.textColor)),
                          prefixStyle: TextStyle(
                              color: hexaCodeToColor(AppColors.textColor),
                              fontSize: 18.0),
                          /* Prefix Text */
                          filled: true,
                          fillColor: hexaCodeToColor(AppColors.cardColor),
                          enabledBorder: myTextInputBorder(
                              modelUserInfo.passwordCon.text != ""
                                  ? hexaCodeToColor("#FFFFFF").withOpacity(0.3)
                                  : Colors.transparent),
                          /* Enable Border But Not Show Error */
                          border: errorOutline(),
                          /* Show Error And Red Border */
                          focusedBorder: myTextInputBorder(
                              hexaCodeToColor("#FFFFFF").withOpacity(0.3)),
                          /* Default Focuse Border Color*/
                          focusColor: hexaCodeToColor("#ffffff"),
                          /* Border Color When Focusing */
                          contentPadding: EdgeInsets.fromLTRB(
                              21, 23, 21, 23), // Default padding =
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(4)],
                        /* Limit Length Of Text Input */
                        onChanged: onChanged,
                        onFieldSubmitted: (value) {
                          onSubmit();
                        },
                      )),

                  Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          child: Switch(
                            value: menuModel.switchBio,
                            onChanged: (value) {
                              switchBio(value);
                            },
                          ),
                        ),
                        MyText(
                          text: "Fingerprint",
                          color: "#FFFFFF",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
        Expanded(
          child: Container(),
        ),
        MyFlatButton(
            textButton: "Submit",
            edgeMargin: EdgeInsets.only(top: 29, left: 66, right: 66),
            hasShadow: modelUserInfo.enable,
            action: modelUserInfo.enable == false ? null : submitProfile)
      ],
    );
  }
}
