import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/menu/account.dart';

class MenuBody extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  final MenuModel model;
  final Function switchBio;

  MenuBody({
    this.userInfo,
    this.model,
    this.switchBio,
  });

  Widget build(BuildContext context) {
    return Column(children: [
      MenuHeader(userInfo: userInfo),

      // History
      MenuSubTitle(index: 0),

      MyListTile(
        index: 0,
        subIndex: 0,
        onTap: () {
          Navigator.pop(context, '');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TrxActivity()));
        },
      ),

      // MyListTile(
      //   index: 0,
      //   subIndex: 1,
      //   onTap: () {
      //     // callBack(_result);
      //     Navigator.pop(context, '');
      //   },
      // ),

      // Wallet
      MenuSubTitle(index: 1),

      MyListTile(
        index: 1,
        subIndex: 0,
        onTap: () {
          //  Navigator.pop(context);
          Navigator.pushNamed(context, ReceiveWallet.route);
          //createPin(context);
        },
      ),

      MyListTile(
        index: 1,
        subIndex: 1,
        onTap: () {
          Navigator.pushNamed(context, AddAsset.route);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => AddAsset(),
          //     ));
        },
      ),

      // Security
      MenuSubTitle(index: 2),

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
      MenuSubTitle(index: 3),

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
