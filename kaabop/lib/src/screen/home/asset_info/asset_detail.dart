import 'package:flutter/material.dart';

import '../../../../index.dart';

class AssetDetail extends StatelessWidget {
  final Market marketData;
  const AssetDetail(this.marketData);
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
            textRow('Price', '\$${marketData.currentPrice}', ''),
            line(),
            textRow('Price Change 24h', '\$${marketData.priceChange24H} ',
                ' ${marketData.priceChangePercentage24H}%'),
            line(),
            textRow('24h Low / 24 High', '\$${marketData.low24H} / \$${marketData.high24H}',
                ''),
            line(),
            textRow('Market Rank', '#${marketData.marketCapRank}', ''),
            const SizedBox(height: 20),
            const MyText(
              text: 'Market Cap',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow('Market Cap', '\$${marketData.marketCap}', ''),
            line(),
            textRow('Market Cap Change 24h',
                '\$${marketData.marketCapChange24H}', ''),
            const SizedBox(height: 20),
            const MyText(
              text: 'Price History',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow('All Time High', '\$${marketData.ath}', ''),
            line(),
            textRow('All Time Low', '\$${marketData.atl}', ''),
            const SizedBox(height: 20),
            const MyText(
              text: 'Supply',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow(
                'Circulating Supply', '\$${marketData.circulatingSupply}', ''),
            line(),
            textRow('Total Supply', '\$${marketData.totalSupply}', ''),
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

  Widget textRow(String leadingText, String trailingText, String endingText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: leadingText,
            color: '#FFFFFF',
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              MyText(
                text: trailingText,
                color: '#FFFFFF',
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
              MyText(
                text: endingText,
                color: endingText != '' && endingText.substring(1, 2) == '-'
                    ? '#FF0000'
                    : '#00FF00',
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
