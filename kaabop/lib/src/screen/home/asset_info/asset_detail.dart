import 'package:flutter/material.dart';

import '../../../../index.dart';

class AssetDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyText(
              text: 'Price Today',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow('Price', '\$1.61'),
            line(),
            textRow('Price Change 24h', '\$-0.001102 -0.07%'),
            line(),
            textRow('24h Low / 24 High', '\$1.61 / \$1.75'),
            line(),
            textRow('Market Rank', '#7'),
            const SizedBox(
              height: 25,
            ),
            const MyText(
              text: 'Market Cap',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow('Market Cap', '\$51,753,244,083.80'),
            line(),
            textRow('Market Cap Change 24h', '\$-598773221.6576004'),
            line(),
          ],
        ),
      ),
    );
  }

  Widget line() {
    return Container(
      height: 1,
      color: hexaCodeToColor(AppColors.textColor),
    );
  }

  Widget textRow(String leadingText, String trailingText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: leadingText,
            color: '#FFFFFF',
            overflow: TextOverflow.ellipsis,
          ),
          MyText(
            text: trailingText,
            color: '#FFFFFF',
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
