import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class SwapDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: [
        MyText(
          width: double.infinity,
          text: 'Swapping Note',
          fontWeight: FontWeight.bold,
          color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          bottom: 4.0,
          top: 32.0,
          left: 16.0,
        ),
        MyText(
          width: double.infinity,
          text:
              'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
          fontWeight: FontWeight.bold,
          color:
              isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
          fontSize: 14.0,
          textAlign: TextAlign.start,
          bottom: 4.0,
          top: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        MyText(
          width: double.infinity,
          text:
              '🚀 Swap rewards: this is part of the airdrop 2. For example, if you have 100 SEL v1, after swapped you will have 200 SEL v2 to keep and use in the future.',
          fontWeight: FontWeight.bold,
          color:
              isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
          fontSize: 14.0,
          textAlign: TextAlign.start,
          bottom: 4.0,
          top: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        MyText(
          width: double.infinity,
          text:
              '🚀 SEL v2 will be the utility token for Selendra with cross-chains capability. This meant that SEL v2 will be able to perform on both Selendra network as well as other network such as Polygon, Ethereum, BSC.',
          fontWeight: FontWeight.bold,
          color:
              isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
          fontSize: 14.0,
          textAlign: TextAlign.start,
          bottom: 4.0,
          top: 16.0,
          left: 16.0,
          right: 16.0,
        ),
      ],
    );
  }
}
