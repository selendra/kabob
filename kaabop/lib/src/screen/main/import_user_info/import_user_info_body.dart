import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class ImportUserInfoBody extends StatelessWidget {

  final ModelUserInfo modelUserInfo;
  final Function onSubmit;
  final String Function(String) onChanged;
  final Function(String) changeGender;
  final String Function(String) validateFirstName;
  final String Function(String) validatepassword;
  final String Function(String) validateConfirmPassword;
  final void Function() submitProfile;
  final Function popScreen;
  final Function switchBio;
  final MenuModel menuModel;
  final PopupMenuItem Function(Map<String, dynamic>) item;

  const ImportUserInfoBody({
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
    this.menuModel,
    this.item
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: <Widget>[

        MyAppBar(
          title: "User Information",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        
        Expanded(
          child: Form(
            key: modelUserInfo.formStateAddUserInfo,
            child: BodyScaffold(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  MyInputField(
                    pBottom: 16.0,
                    labelText: "Username",
                    textInputFormatter: [
                      LengthLimitingTextInputFormatter(
                        TextField.noMaxLength,
                      )
                    ],
                    controller: modelUserInfo.userNameCon,
                    focusNode: modelUserInfo.userNameNode,
                    validateField: validateFirstName,
                    onChanged: onChanged,
                    onSubmit: onSubmit,
                  ),
                  
                  MyInputField(
                    labelText: "Pin",
                    pBottom: 16,
                    controller: modelUserInfo.passwordCon,
                    focusNode: modelUserInfo.passwordNode, 
                    obcureText: true,
                    onChanged: onChanged,
                    textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                    onSubmit: onSubmit
                  ),

                  MyInputField(
                    labelText: "Confirm Pin",
                    pBottom: 16,
                    controller: modelUserInfo.confirmPasswordCon,
                    focusNode: modelUserInfo.confirmPasswordNode, 
                    obcureText: true,
                    onChanged: onChanged,
                    textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                    onSubmit: onSubmit
                  ),

                  Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        SizedBox(
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
                          color: isDarkTheme
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        ),

        Expanded(child: Container()),
        MyFlatButton(
          edgePadding: EdgeInsets.symmetric(vertical: 16),
          textButton: "Submit",
          edgeMargin: const EdgeInsets.only(
            top: 29,
            left: 66,
            right: 66,
          ),
          hasShadow: modelUserInfo.enable,
          action: modelUserInfo.enable == false ? null : submitProfile,
        )
      ],
    );
  }
}
