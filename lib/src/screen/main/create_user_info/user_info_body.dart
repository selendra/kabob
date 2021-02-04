import 'package:wallet_apps/index.dart';

class MyUserInfoBody extends StatelessWidget{
  
  final ModelUserInfo modelUserInfo;
  final Function onSubmit;
  final Function onChanged;
  final Function changeGender;
  final Function validateFirstName;
  final Function validateMidName;
  final Function validateLastName;
  final Function submitProfile;
  final Function popScreen;
  final Function switchBio;
  final PopupMenuItem Function(Map<String, dynamic>) item;

  MyUserInfoBody({
    this.modelUserInfo,
    this.onSubmit,
    this.onChanged,
    this.changeGender,
    this.validateFirstName,
    this.validateMidName,
    this.validateLastName,
    this.submitProfile,
    this.popScreen,
    this.switchBio,
    this.item
  });

  Widget build(BuildContext context){
    return Column(
      children: <Widget>[

        MyAppBar(
          title: "User Information",
          onPressed: (){
            Navigator.pop(context);
          },
        ),

        Container(
          margin: EdgeInsets.only(top: 20),
          child: Form(
            key: modelUserInfo.formStateAddUserInfo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                MyInputField(
                  pBottom: 16.0,
                  labelText: "User name",
                  textInputFormatter: [LengthLimitingTextInputFormatter(TextField.noMaxLength)],
                  controller: modelUserInfo.userNameCon, 
                  focusNode: modelUserInfo.userNameNode,
                  validateField: validateFirstName, 
                  textColor: "#FFFFFF",
                  onChanged: onChanged, 
                  onSubmit: onSubmit
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: TextFormField(
                    key: this.key,
                    enabled: true,
                    focusNode: modelUserInfo.passwordNode, 
                    validator: validateMidName,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: modelUserInfo.passwordCon,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: hexaCodeToColor("#FFFFFF"), fontSize: 18.0),
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                          fontSize: 18.0,
                          color: modelUserInfo.passwordNode.hasFocus || modelUserInfo.passwordCon.text != ""
                              ? hexaCodeToColor("#FFFFF").withOpacity(0.3)
                              : hexaCodeToColor(AppColors.textColor)),
                      prefixStyle: TextStyle(
                          color: hexaCodeToColor(AppColors.textColor), fontSize: 18.0),
                      /* Prefix Text */
                      filled: true,
                      fillColor: hexaCodeToColor(AppColors.cardColor),
                      enabledBorder: myTextInputBorder(modelUserInfo.passwordCon.text != ""
                          ? hexaCodeToColor("#FFFFFF").withOpacity(0.3)
                          : Colors.transparent),
                      /* Enable Border But Not Show Error */
                      border: errorOutline(),
                      /* Show Error And Red Border */
                      focusedBorder:
                          myTextInputBorder(hexaCodeToColor("#FFFFFF").withOpacity(0.3)),
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
                    validator: validateLastName, 
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: hexaCodeToColor("#FFFFFF"), fontSize: 18.0),
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(
                          fontSize: 18.0,
                          color: modelUserInfo.passwordNode.hasFocus || modelUserInfo.passwordCon.text != ""
                              ? hexaCodeToColor("#FFFFF").withOpacity(0.3)
                              : hexaCodeToColor(AppColors.textColor)),
                      prefixStyle: TextStyle(
                          color: hexaCodeToColor(AppColors.textColor), fontSize: 18.0),
                      /* Prefix Text */
                      filled: true,
                      fillColor: hexaCodeToColor(AppColors.cardColor),
                      enabledBorder: myTextInputBorder(modelUserInfo.passwordCon.text != ""
                          ? hexaCodeToColor("#FFFFFF").withOpacity(0.3)
                          : Colors.transparent),
                      /* Enable Border But Not Show Error */
                      border: errorOutline(),
                      /* Show Error And Red Border */
                      focusedBorder:
                          myTextInputBorder(hexaCodeToColor("#FFFFFF").withOpacity(0.3)),
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

                // MyInputField(
                //   pBottom: 16.0,
                //   labelText: "Confirm Password",
                //   controller: modelUserInfo.confirmPasswordCon, 
                //   focusNode: modelUserInfo.confirmPasswordNode, 
                //   validateField: validateMidName, 
                //   textColor: "#FFFFFF",
                //   onChanged: onChanged, 
                //   inputAction: TextInputAction.done,
                //   onSubmit: onSubmit
                // ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      child: Switch(
                        value: true,
                        onChanged: switchBio,
                      ),
                    ),

                    MyText(
                      text: "Figner print",
                      color: "#FFFFFF",
                    )
                  ],
                )
              ],
            ),
          )
        ),

        Expanded(
          child: Container(),
        ),

        MyFlatButton(
          textButton: "Submit",
          edgeMargin: EdgeInsets.only(top: 29, left: 66, right: 66),
          hasShadow: modelUserInfo.enable,
          action: modelUserInfo.enable == false ? null : submitProfile
        )
      ],
    );
  }
}


