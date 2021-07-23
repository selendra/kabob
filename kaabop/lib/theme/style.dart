import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class AppStyle {
  static ThemeData myTheme(BuildContext context) {

    final isDarkMode = Provider.of<ThemeProvider>(context).isDark;

    return ThemeData(
      scaffoldBackgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor("#F5F5F5"),
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(bodyText2: TextStyle(color: hexaCodeToColor(AppColors.appBarTextColor))),
        color: Colors.transparent,
        iconTheme: IconThemeData(color: hexaCodeToColor(AppColors.appBarTextColor))
      ),
      /* Color All Text */
      textTheme: TextTheme(bodyText2: TextStyle(color: hexaCodeToColor(AppColors.textColor))),
      canvasColor: hexaCodeToColor("#FFFFFF"),
      //cardColor: hexaCodeToColor(AppConfig.darkBlue50.toString()),

      // bottomAppBarTheme:
      //     BottomAppBarTheme(color: hexaCodeToColor(AppColors.cardColor)),
      // floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: hexaCodeToColor(AppColors.textColor)),
      fontFamily: "Avenir",
      unselectedWidgetColor: Colors.white,
      // scaffoldBackgroundColor:
      //     Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
    );
  }
}
