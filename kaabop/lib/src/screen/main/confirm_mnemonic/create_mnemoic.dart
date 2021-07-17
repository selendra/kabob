import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class CreateMnemonic extends StatefulWidget {
  final String passPhrase;
  final List passPhraseList;
  const CreateMnemonic(this.passPhrase, this.passPhraseList);

  @override
  _CreateMnemonicState createState() => _CreateMnemonicState();
}

class _CreateMnemonicState extends State<CreateMnemonic> {
  @override
  void initState() {
    disableScreenShot();
    super.initState();
  }

  Future<void> disableScreenShot() async {
    await FlutterScreenshotSwitcher.disableScreenshots();
  }

  Future<void> enableScreenShot() async {
    await FlutterScreenshotSwitcher.enableScreenshots();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              color: isDarkTheme
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.cardColor),
              title: AppText.createAccTitle,
              onPressed: enableScreenShot,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        text: AppText.backupMnemonic,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                        bottom: 12,
                      )),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      textAlign: TextAlign.left,
                      text: AppText.keepMnemonic,
                      fontWeight: FontWeight.w500,
                      color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                      bottom: 12,
                    ),
                  ),

                  // Display Mnemonic
                  if (widget.passPhrase == null)
                    CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(
                        hexaCodeToColor(AppColors.secondary),
                      ),
                    )
                  else
                    Card(
                      color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkCard)
                          : hexaCodeToColor(AppColors.cardColor),
                      child: MyText(
                        text: widget.passPhrase ?? '',
                        textAlign: TextAlign.left,
                        fontSize: 25,
                        color: AppColors.secondarytext,
                        fontWeight: FontWeight.bold,
                        pLeft: 16,
                        right: 16,
                        top: 16,
                        bottom: 16,
                      ),
                    ),
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
              edgeMargin:
                  const EdgeInsets.only(left: 66, right: 66, bottom: 16),
              textButton: AppText.next,
              action: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmMnemonic(
                      widget.passPhrase,
                      widget.passPhraseList,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
