import 'package:wallet_apps/index.dart';

class MenuModel {
  bool switchBio = false;
  bool switchPasscode = false;
  bool authenticated;

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Map result = {};

  static const List listTile = [
    {
      'title': "History",
      'sub': [
        {'icon': "assets/icons/history.svg", 'subTitle': 'History'},
        {'icon': "assets/icons/history.svg", 'subTitle': 'Activity'}
      ]
    },
    {
      'title': "Wallet",
      'sub': [
        {'icon': "assets/icons/wallet.svg", 'subTitle': 'Wallet'},
        {'icon': "assets/icons/plus.svg", 'subTitle': 'Asset'}
      ]
    },
    {
      'title': "Airdrop",
      'sub': [
        {'icon': "assets/icons/form.svg", 'subTitle': 'Claim SEL'},
        {'icon': "assets/icons/form.svg", 'subTitle': 'Claim KGO'},
      ]
    },
    {
      'title': "Security",
      'sub': [
        {'icon': "assets/icons/password.svg", 'subTitle': 'Passcode'},
        {'icon': "assets/icons/finger_print.svg", 'subTitle': 'Fingerprint'}
      ]
    },
    {
      'title': "Join community",
      'sub': [
        {'icon': "assets/icons/edit_user.svg", 'subTitle': 'Account'},
      ]
    },
    {
      'title': "About",
      'sub': [
        {'icon': "assets/icons/edit_user.svg", 'subTitle': 'Privacy Policy'},
        {'icon': "assets/icons/edit_user.svg", 'subTitle': 'Term of Use'},
      ]
    },
  ];
}
