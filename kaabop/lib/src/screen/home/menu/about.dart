import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/components/component.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../index.dart';

class About extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: _scaffoldKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: "About",
              color: isDarkTheme
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.whiteHexaColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                _launchInBrowser('https://bitriel.com/privacy');
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Privacy Policy',
                      color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                      textAlign: TextAlign.left,
                    ),
                    MyText(
                      top: 4.0,
                      text: 'Read our full Privacy Policy',
                      fontSize: 16,
                      textAlign: TextAlign.left,
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _launchInBrowser('https://bitriel.com/termofuse');
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Terms of Use',
                      textAlign: TextAlign.left,
                      color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 4.0,
                      text: 'Read our term of use for Bitriel app',
                      fontSize: 16,
                      textAlign: TextAlign.left,
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Contact',
                      textAlign: TextAlign.left,
                      color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 4.0,
                      text:
                          'For questions, concerns, or comments can be address to: ',
                      fontSize: 16,
                      textAlign: TextAlign.left,
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                    Row(
                      children: [
                        MyText(
                          top: 4.0,
                          text: 'info@bitriel.com',
                          fontSize: 16,
                          textAlign: TextAlign.left,
                          color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              const ClipboardData(text: 'info@bitriel.com'),
                            ).then(
                              (value) => {
                                // ignore: deprecated_member_use
                                _scaffoldKey.currentState.showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to Clipboard'),
                                  ),
                                )
                              },
                            );
                          },
                          icon: Icon(
                            Icons.copy,
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'About',
                      textAlign: TextAlign.left,
                      color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 6.0,
                      text:
                          'Bitriel Wallets are used to store and transact SEL tokens and multiple other cryptocoins. Wallets can be integrated into any application where a use case exists, connecting the application to the Selendra main chain.',
                      fontSize: 16,
                      textAlign: TextAlign.left,
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
