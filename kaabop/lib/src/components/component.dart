// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/get_wallet.m.dart';

class Component {
  static void popScreen(BuildContext context) {
    Navigator.pop(context);
  }

  static Future messagePermission(
      {BuildContext context, String content, void Function() method}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Align(
            child: Text("Message"),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(content, textAlign: TextAlign.center),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: method,
              child: const Text('Setting'),
            ),
          ],
        );
      },
    );
  }
}

class MyFlatButton extends StatelessWidget {
  final String textButton;
  final String buttonColor;
  final FontWeight fontWeight;
  final double fontSize;
  final EdgeInsetsGeometry edgeMargin;
  final EdgeInsetsGeometry edgePadding;
  final bool hasShadow;
  final void Function() action;
  final double width;
  final double height;

  const MyFlatButton({
    this.textButton,
    this.buttonColor = AppColors.secondary,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 18,
    this.edgeMargin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.edgePadding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.hasShadow = false,
    this.width = double.infinity,
    this.height,
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Container(
      padding: edgePadding,
      margin: edgeMargin,
      width: width,
      height: height,

      decoration: BoxDecoration(borderRadius: BorderRadius.circular(size5), boxShadow: [
        if (hasShadow)
          BoxShadow(
            color: Colors.black54.withOpacity(0.3),
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: const Offset(2.0, 5.0),
          )
      ]),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: action,
        color: hexaCodeToColor(buttonColor),
        disabledColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade400,
        focusColor: hexaCodeToColor(AppColors.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: MyText(
          pTop: 20,
          pBottom: 20,
          text: textButton,
          color: isDarkTheme ? '#FFFFFF' : AppColors.textBtnColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  final String text;
  final String color;
  final double fontSize;
  final FontWeight fontWeight;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final double pTop;
  final double pRight;
  final double pBottom;
  final double pLeft;
  final double width;
  final double height;
  final TextAlign textAlign;
  final TextOverflow overflow;

  const MyText({
    this.text,
    this.color = AppColors.textColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
    this.pLeft = 0,
    this.pRight = 0,
    this.pTop = 0,
    this.pBottom = 0,
    this.width,
    this.height,
    this.textAlign = TextAlign.center,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      padding: EdgeInsets.fromLTRB(pLeft, pTop, pRight, pBottom),
      child: SizedBox(
        width: width,
        height: height,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            color: Color(AppUtils.convertHexaColor(color)),
            fontSize: fontSize
          ),
          textAlign: textAlign,
          overflow: overflow,
        ),
      ),
    );
  }
}

class MyLogo extends StatelessWidget {
  final String logoPath;
  final String color;
  final double width;
  final double height;

  final double top;
  final double right;
  final double bottom;
  final double left;

  const MyLogo(
      {@required this.logoPath,
      this.color = "#FFFFFF",
      this.width = 60,
      this.height = 60,
      this.top = 0,
      this.right = 0,
      this.bottom = 0,
      this.left = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: SvgPicture.asset(
        logoPath,
        width: width,
        height: height,
        color: hexaCodeToColor(color),
      ),
    );
  }
}

class MyCircularImage extends StatelessWidget {
  final String boxColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final String imagePath;
  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;
  final bool enableShadow;
  final BoxDecoration decoration;
  final Color colorImage;

  const MyCircularImage(
      {this.boxColor = AppColors.secondary,
      this.margin = const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
      this.imagePath,
      this.width,
      this.height,
      this.imageWidth,
      this.imageHeight,
      this.enableShadow,
      this.decoration,
      this.colorImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: padding,
      decoration: decoration,
      child: SvgPicture.asset(
        imagePath,
        color: colorImage,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  final double pLeft;
  final double pTop;
  final double pRight;
  final double pBottom;
  final EdgeInsetsGeometry margin;
  final String title;
  final void Function() onPressed;
  final Color color;
  final Widget tile;

  const MyAppBar({
    this.pLeft = 0,
    this.pTop = 0,
    this.pRight = 0,
    this.pBottom = 0,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    @required this.title,
    this.color,
    this.onPressed,
    this.tile
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return SafeArea(
      child: Container(
        height: 65.0,
        width: MediaQuery.of(context).size.width,
        margin: margin,
        decoration: BoxDecoration(
          color: isDarkTheme
            ? hexaCodeToColor(AppColors.darkCard)
            : hexaCodeToColor(AppColors.whiteHexaColor),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black54.withOpacity(0.5),
          //     blurRadius: 8.0,
          //     spreadRadius: 1.0,
          //     offset: const Offset(0, 2),
          //   )
          // ]
        ),
        // color ?? hexaCodeToColor(AppColors.whiteHexaColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  /* Menu Icon */

                  padding: const EdgeInsets.only(left: 30),
                  iconSize: 40.0,
                  icon: Icon(
                    Platform.isAndroid ? LineAwesomeIcons.arrow_left : LineAwesomeIcons.angle_left,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 30,
                  ),
                  onPressed: onPressed,
                ),
                MyText(
                  color: isDarkTheme
                    ? AppColors.whiteColorHexa
                    : AppColors.textColor,
                  text: title,
                  left: 15,
                  fontSize: 22,
                  fontWeight: FontWeight.w600
                ),
              ],
            ),
            tile ?? Container()
          ],
        )
      )
    );
  }
}

class BodyScaffold extends StatelessWidget {
  
  final double left, top, right, bottom;
  final Widget child;
  final double width;
  final double height;
  final ScrollPhysics physic;
  final bool isSafeArea;

  const BodyScaffold({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 16,
    this.child,
    this.height,
    this.width,
    this.physic,
    this.isSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return SingleChildScrollView(
      physics: physic,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        color: isDarkTheme
          ? Color(AppUtils.convertHexaColor(AppColors.darkBgd))
          : Color(AppUtils.convertHexaColor("#F5F5F5")),
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: isSafeArea ? SafeArea(child: child) : child,
      )
    );
  }
}

class MyIconButton extends StatelessWidget {
  final String icon;
  final double iconSize;
  final void Function() onPressed;
  // final EdgeInsetsGeometry padding;

  const MyIconButton({
    this.icon,
    this.iconSize,
    // this.padding = const EdgeInsets.all(0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: SvgPicture.asset(
        'assets/icons/$icon',
        width: iconSize ?? 30,
        height: iconSize ?? 30,
        color: isDarkTheme ? Colors.white : Colors.black,
      ),
    );
  }
}

class MyCusIconButton extends StatelessWidget {
  final String icon;
  final double iconSize;
  final void Function() onPressed;
  final EdgeInsetsGeometry padding;

  const MyCusIconButton({
    this.icon,
    this.iconSize = 30,
    this.padding = const EdgeInsets.all(0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: GestureDetector(
        onTap: onPressed,
        child: Image.asset(icon, width: 30, height: 30, color: Colors.white),
      ),
    );
  }
}

// class MyCircularChart extends StatelessWidget {
//   final String amount;
//   final GlobalKey<AnimatedCircularChartState> chartKey;
//   final EdgeInsetsGeometry margin;
//   final List<CircularSegmentEntry> listChart;
//   final Alignment alignment;
//   final double width;
//   final double height;

//   MyCircularChart(
//       {this.amount,
//       this.chartKey,
//       this.margin = const EdgeInsets.only(bottom: 24.0),
//       this.alignment,
//       this.width = 300.0,
//       this.height = 250.0,
//       this.listChart});

//   Widget build(BuildContext context) {
//     return Container(
//         margin: margin,
//         alignment: alignment,
//         child: AnimatedCircularChart(
//           holeRadius: 70.0,
//           key: chartKey,
//           duration: Duration(seconds: 1),
//           // startAngle: 125.0,
//           size: Size(width, height),
//           percentageValues: true,
//           // holeLabel: amount,
//           // labelStyle:TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, ),
//           edgeStyle: SegmentEdgeStyle.flat,
//           initialChartData: <CircularStackEntry>[
//             CircularStackEntry(
//               listChart,
//               rankKey: 'progress',
//             ),
//           ],
//           chartType: CircularChartType.Radial,
//         ));
//   }
// }

class MyRowHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 1.5),
                alignment: Alignment.centerLeft,
                child: const MyText(text: "Your assets")),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: MyText(text: "QTY"),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTabBar extends StatelessWidget {
  final List<Widget> listWidget;
  final void Function(int) onTap;

  const MyTabBar({@required this.listWidget, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteHexaColor),
            borderRadius: BorderRadius.circular(8)),
        width: 125.0,
        height: 48,
        child: TabBar(
          unselectedLabelColor: hexaCodeToColor(AppColors.textColor),
          indicatorColor: hexaCodeToColor(AppColors.secondarytext),
          labelColor: hexaCodeToColor(AppColors.secondarytext),
          // labelStyle: TextStyle(fontSize: 30.0),
          tabs: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
              width: double.infinity,
              child: const Icon(
                LineAwesomeIcons.phone,
                size: 23.0,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              alignment: Alignment.center,
              child: const Icon(LineAwesomeIcons.envelope, size: 23.0),
            )
          ],
          onTap: onTap,
        ),
      ),
    );
  }
}

/* Trigger Snack Bar Function */
void snackBar(BuildContext context, String contents) {
  final snackbar = SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(contents),
  );
  // ignore: deprecated_member_use
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // globalKey.currentState.showSnackBar(snackbar);
}

class MyPinput extends StatelessWidget {
  final String obscureText;
  final GetWalletModel getWalletM;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final void Function(String) onSubmit;

  const MyPinput({
    this.obscureText = '⚪',
    this.getWalletM,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      margin: const EdgeInsets.only(bottom: 30),
      child: PinPut(
        obscureText: obscureText,
        focusNode: focusNode,
        controller: controller,
        fieldsCount: 4,
        selectedFieldDecoration: getWalletM.pinPutDecoration.copyWith(
            color: Colors.grey.withOpacity(0.5),
            border: Border.all(
              color: Colors.grey,
            )),
        submittedFieldDecoration: getWalletM.error
            ? getWalletM.pinPutDecoration
                .copyWith(border: Border.all(color: Colors.red))
            : getWalletM.pinPutDecoration,
        followingFieldDecoration: getWalletM.error
            ? getWalletM.pinPutDecoration
                .copyWith(border: Border.all(color: Colors.red))
            : getWalletM.pinPutDecoration,
        eachFieldConstraints: getWalletM.boxConstraint,
        textStyle: const TextStyle(fontSize: 18, color: Colors.white),
        onChanged: onChanged,
        onSubmit: onSubmit,
      ),
    );
  }
}
