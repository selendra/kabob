import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:wallet_apps/index.dart';

class CreateMnemonic extends StatefulWidget {
  final CreateAccModel accModel;

  CreateMnemonic({this.accModel});

  @override
  _CreateMnemonicState createState() => _CreateMnemonicState();
}

class _CreateMnemonicState extends State<CreateMnemonic> {
  @override
  void initState() {
    disableScreenShot();
    super.initState();
  }

  void disableScreenShot() async {
    await FlutterScreenshotSwitcher.disableScreenshots();
  }

  void enableScreenShot() async {
    await FlutterScreenshotSwitcher.enableScreenshots();
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              color: hexaCodeToColor(AppColors.cardColor),
              title: AppText.createAccTitle,
              onPressed: enableScreenShot,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        text: AppText.backupMnemonic,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColorHexa,
                        bottom: 12,
                      )),
                  MyText(
                    textAlign: TextAlign.left,
                    text: AppText.keepMnemonic,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColorHexa,
                    bottom: 12,
                  ),

                  // Display Mnemonic
                  widget.accModel.mnemonic == null
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(
                              hexaCodeToColor(AppColors.secondary)),
                        )
                      : Card(
                          child: MyText(
                              text: widget.accModel.mnemonic ?? '',
                              textAlign: TextAlign.left,
                              fontSize: 25,
                              color: AppColors.secondary_text,
                              fontWeight: FontWeight.bold,
                              pLeft: 16,
                              right: 16,
                              top: 16,
                              bottom: 16))
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: MyText(
                  textAlign: TextAlign.start,
                  text: AppText.screenshotNote,
                ),
              ),
            ),
            MyFlatButton(
              edgeMargin: EdgeInsets.only(left: 66, right: 66, bottom: 16),
              textButton: AppText.next,
              action: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConfirmMnemonic(widget.accModel)));
              },
            )
          ],
        ),
      ),
    );
  }
}
