import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/menu/account.dart';

import 'add_asset/search_asset.dart';

class MenuBody extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  final MenuModel model;
  final Function switchBio;

  const MenuBody({
    this.userInfo,
    this.model,
    this.switchBio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MenuHeader(userInfo: userInfo),

      // History
      const MenuSubTitle(index: 0),

      MyListTile(
        index: 0,
        subIndex: 0,
        onTap: () {
          Navigator.pop(context, '');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrxActivity(),
            ),
          );
        },
      ),

      // Wallet
      const MenuSubTitle(index: 1),

      MyListTile(
        index: 1,
        subIndex: 0,
        onTap: () {
          Navigator.pushNamed(context, ReceiveWallet.route);
        },
      ),

      MyListTile(
        index: 1,
        subIndex: 1,
        onTap: () {
          showSearch(
            context: context,
            delegate: SearchAsset(),
          );
        },
      ),

      // Security
      const MenuSubTitle(index: 2),
      MyListTile(
        enable: false,
        index: 2,
        subIndex: 1,
        trailing: Switch(
          value: model.switchPasscode,
          onChanged: (value) {
            Navigator.pushNamed(context, Passcode.route);
          },
        ),
        onTap: null,
      ),

      MyListTile(
        enable: false,
        index: 2,
        subIndex: 2,
        trailing: Switch(
          value: model.switchBio,
          onChanged: (value) {
            switchBio(value);
          },
        ),
        onTap: null,
      ),

      // Account
      const MenuSubTitle(index: 3),

      MyListTile(
        index: 3,
        subIndex: 0,
        onTap: () async {
          Navigator.popAndPushNamed(context, Account.route);
        },
      ),
    ]);
  }
}
