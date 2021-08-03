import 'package:flutter/material.dart';

import '../../../../index.dart';

class AssetInfoBody extends StatelessWidget {
  final String assetLogo;
  final String balance;
  final String assetSymbol;
  final String marketPrice;
  final String priceChange24h;

  const AssetInfoBody(
    this.assetLogo,
    this.balance,
    this.assetSymbol,
    this.marketPrice,
    this.priceChange24h,
  );
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   margin: const EdgeInsets.only(right: 16),
          //   width: 80,
          //   height: 80,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(5),
          //   ),
          //   child: Image.asset(
          //     assetLogo,
          //     fit: BoxFit.contain,
          //   ),
          // ),
          MyText(
            text: '$balance${' $assetSymbol'}',
            color: AppColors.textColor, //AppColors.secondarytext,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
          const MyText(
            top: 8.0,
            text: '\$0.00',
            color: AppColors.textColor, //AppColors.secondarytext,
            fontSize: 28,
            //fontWeight: FontWeight.bold,
          ),

          // Row(
          //   children: [
          //     MyText(
          //       text: '\$ $marketPrice' ?? '',
          //       fontSize: 14,
          //       fontWeight: FontWeight.bold,
          //       color: "#FFFFFF",
          //     ),
          //     const SizedBox(width: 6.0),
          //     MyText(
          //       text: priceChange24h.substring(0, 1) == '-'
          //           ? '$priceChange24h%'
          //           : '+$priceChange24h%',
          //       fontSize: 14,
          //       fontWeight: FontWeight.bold,
          //       color: priceChange24h.substring(0, 1) == '-'
          //           ? '#FF0000'
          //           : '#00FF00',
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
