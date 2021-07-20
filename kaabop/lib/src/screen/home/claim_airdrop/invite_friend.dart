import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../../../index.dart';

class InviteFriend extends StatelessWidget {
  final _globalKey = GlobalKey<ScaffoldState>();

  Future<void> referralShare(GlobalKey globalKey, String referralLink) async {
    try {
      Share.share(
          'Join me to claim more Selendra \$SEL token airdrop! Click $referralLink to claim your tokens! Connect with people in community @ t.me/selendraorg  http://twitter.com/selendraorg');

      //Follow Selendra and get free $SEL tokens. Share twitter.com/selendraorg to get more $SEL. Claim it at https://selendra-airdrop.netlify.app/claim-$sel?ref=38034120c302. Join t.me/selendraorg to connect with others in the community.
      //Share.shareFiles([file.path], text: referralLink);
    } catch (e) {
      //print(e.toString());
    }
  }

  void copyAndShowSnackBar(String copyText, String snackBarContent,
      GlobalKey<ScaffoldState> _globalKey) {
    Clipboard.setData(
      ClipboardData(text: copyText ?? ''),
    );
    snackBar(snackBarContent, _globalKey);
  }

  void snackBar(String contents, GlobalKey<ScaffoldState> _globalKey) {
    final snackbar = SnackBar(
      content: Text(contents),
    );
    // ignore: deprecated_member_use
    _globalKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final ethAdd = Provider.of<ContractProvider>(context, listen: false).ethAdd;
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: _globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            
            MyAppBar(
              title: 'Invite Friends',
              color: isDarkTheme
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.whiteHexaColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(40),
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.asset(
                        'assets/share_social.png',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const MyText(
                    text: 'Invite Friends.',
                    color: '#FFFFFF',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  const MyText(
                    top: 8,
                    text: 'Earn \$SEL Together',
                    color: '#FFFFFF',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  const MyText(
                    top: 35,
                    text:
                        'Earn 3 \$SEL together every time your friends use your referral id.',
                    color: '#FFFFFF',
                    left: 16.0,
                    right: 16.0,
                    fontSize: 16.0,
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                  _referallRow(
                    'Referral ID :    ',
                    ethAdd, //.substring(ethAdd.length - 12),
                    200,
                    () {
                      copyAndShowSnackBar(
                        ethAdd, //.substring(ethAdd.length - 12),
                        'Referral ID Copied',
                        _globalKey,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  _referallRow(
                    'Referral Link :',
                    AppConfig.testInviteLink1 +
                        ethAdd, //.substring(ethAdd.length - 12),
                    200,
                    () {
                      copyAndShowSnackBar(
                        AppConfig.testInviteLink1 +
                            ethAdd, //s.substring(ethAdd.length - 12),
                        'Referral Link Copied',
                        _globalKey,
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                        referralShare(
                          _globalKey,
                          AppConfig.testInviteLink1 +
                              ethAdd, //.substring(ethAdd.length - 12),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: hexaCodeToColor(AppColors.secondary),
                            size: 30,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: const MyText(
                              text: "SHARE MY REFERRAL",
                              color: "#FFFFFF",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _referallRow(
    String leadingText,
    String trailingText,
    double trailingWidth,
    void Function() onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MyText(
          text: leadingText,
          color: '#FFFFFF',
          textAlign: TextAlign.left,
          fontWeight: FontWeight.bold,
        ),
        Row(
          children: [
            SizedBox(
              width: trailingWidth,
              child: MyText(
                text: trailingText,
                color: '#FFFFFF',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.copy,
                size: 30,
                color: hexaCodeToColor(AppColors.secondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
