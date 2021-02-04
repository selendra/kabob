import 'package:wallet_apps/index.dart';

class ImportUserInfoBody extends StatelessWidget{
  
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
  final PopupMenuItem Function(Map<String, dynamic>) item;

  ImportUserInfoBody({
    this.modelUserInfo,
    this.onSubmit,
    this.onChanged,
    this.changeGender,
    this.validateFirstName,
    this.validatepassword,
    this.validateConfirmPassword,
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
          margin: EdgeInsets.only(top: 16),
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
                
                MyInputField(
                  pBottom: 16.0,
                  labelText: "Password",
                  textInputFormatter: [LengthLimitingTextInputFormatter(TextField.noMaxLength)],
                  controller: modelUserInfo.passwordCon, 
                  focusNode: modelUserInfo.passwordNode, 
                  validateField: validatepassword,
                  textColor: "#FFFFFF",
                  onChanged: onChanged, 
                  onSubmit: onSubmit
                ),

                MyInputField(
                  pBottom: 16.0,
                  labelText: "Confirm Password",
                  textInputFormatter: [LengthLimitingTextInputFormatter(TextField.noMaxLength)],
                  controller: modelUserInfo.confirmPasswordCon, 
                  focusNode: modelUserInfo.confirmPasswordNode, 
                  validateField: validateConfirmPassword, 
                  inputAction: TextInputAction.done,
                  textColor: "#FFFFFF",
                  onChanged: onChanged, 
                  onSubmit: onSubmit
                ),

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

