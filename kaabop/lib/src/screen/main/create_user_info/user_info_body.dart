import 'package:wallet_apps/index.dart';

class MyUserInfoBody extends StatelessWidget {
  
  final ModelUserInfo modelUserInfo;
  final Function onSubmit;
  final String Function(String) onChanged;
  final String Function(String) validateFirstName;
  final String Function(String) validateMidName;
  final String Function(String) validateLastName;
  final void Function() submitProfile;
  final Function popScreen;
  final Function switchBio;
  final MenuModel model;
  final PopupMenuItem Function(Map<String, dynamic>) item;

  const MyUserInfoBody({
    this.modelUserInfo,
    this.onSubmit,
    this.onChanged,
    this.validateFirstName,
    this.validateMidName,
    this.validateLastName,
    this.submitProfile,
    this.popScreen,
    this.switchBio,
    this.model,
    this.item,
  });

  @override
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
            margin: const EdgeInsets.only(top: 20),
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
                    onChanged: onChanged,
                    onSubmit: onSubmit,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: TextFormField(
                      key: key,
                      enabled: true,
                      focusNode: modelUserInfo.passwordNode,
                      validator: validateMidName,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: modelUserInfo.passwordCon,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: hexaCodeToColor("#FFFFFF"), fontSize: 18.0),
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
                        contentPadding: const EdgeInsets.fromLTRB(
                          21,
                          23,
                          21,
                          23,
                        ), // Default padding =
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(4)],
                      /* Limit Length Of Text Input */
                      onChanged: onChanged,
                      onFieldSubmitted: (value) {
                        onSubmit();
                      },
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: TextFormField(
                        key: key,
                        enabled: true,
                        controller: modelUserInfo.confirmPasswordCon,
                        focusNode: modelUserInfo.confirmPasswordNode,
                        validator: validateLastName,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            color: hexaCodeToColor("#FFFFFF"), fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: "Confirm Pin",
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
                          contentPadding: const EdgeInsets.fromLTRB(
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
                      children: [
                        SizedBox(
                          width: 50,
                          child: Switch(
                            value: model.switchBio,
                            onChanged: (value) {
                              switchBio(value);
                            },
                          ),
                        ),
                        const MyText(
                          text: "Fingerprint",
                          color: "#FFFFFF",
                        )
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
          edgeMargin: const EdgeInsets.only(top: 29, left: 66, right: 66),
          hasShadow: modelUserInfo.enable,
          action: modelUserInfo.enable == false ? null : submitProfile,
        )
      ],
    );
  }
}
