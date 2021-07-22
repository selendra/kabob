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
          text: 'The SEL Token v2 features:',
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
              'Token contract verification and other related information to SEL token v2, all available on BSCscan like Whitepaper, Social Channels and other official info.',
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
              '🚀 For future cross-chains transaction; this version is designed to work with others chains like Polygon, Ethereum and other networks.',
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
              '🚀 Use the Token to purchase invitations and share the referral link to join Selendra airdrop opportunity.',
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
