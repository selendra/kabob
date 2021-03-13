import 'package:wallet_apps/index.dart';

Widget paddingScreenWidget(BuildContext context, Widget child) {
  return Container(
    /* Create Whole Screen Background Color */
    color: hexaCodeToColor(AppColors.bgdColor),
    // scaffoldBGColor("#344051", "#222834"),
    constraints: BoxConstraints(
        /* Make Height And Widget To Fit Screen */
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width),
    child: Center(
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding:
                EdgeInsets.only(top: 10, left: 40.0, right: 40, bottom: 10),
            child: child,
          )),
    ),
  );
}

Widget forgotPass(BuildContext context, String color,
    {double fontSize = 18.0,
    FontWeight fontWeight = FontWeight.w500,
    Function method}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, '/forgotPasswordScreen');
    },
    child: Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: textDisplay(
          "Forgot Password?",
          TextStyle(
              color: hexaCodeToColor(color),
              fontSize: fontSize,
              fontWeight: fontWeight)),
    ),
  );
}
