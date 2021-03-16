import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';

class AssetItem extends StatelessWidget {
  final String asset;
  final String tokenSymbol;
  final String org;
  final String balance;
  final Color color;

  const AssetItem(
      this.asset, this.tokenSymbol, this.org, this.balance, this.color);
  @override
  Widget build(BuildContext context) {
    return rowDecorationStyle(
        child: Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(40)),
          child: Image.asset(asset),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: tokenSymbol,
                  color: "#FFFFFF",
                ),
                MyText(text: org, fontSize: 15),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                    width: double.infinity,
                    text: balance ?? '0', //portfolioData[0]["data"]['balance'],
                    color: "#FFFFFF",
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget rowDecorationStyle(
      {Widget child, double mTop = 0, double mBottom = 16}) {
    return Container(
        margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
        padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
        height: 90,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
              offset: Offset(1.0, 1.0),
            )
          ],
          color: hexaCodeToColor(AppColors.cardColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child);
  }
}
