import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';

class QrViewTitle extends StatelessWidget {

  final String assetInfo;

  final String initialValue;

  final Function onChanged;

  QrViewTitle({this.assetInfo, this.initialValue, this.onChanged});

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [

          Align(
            child: MyText(
              text: 'Wallet',
              fontSize: 20.0,
              color: isDarkTheme
                ? AppColors.whiteColorHexa
                : AppColors.textColor,
            ),
          ),
          
          if (assetInfo != null)
            Container()
          else
          Align(
            alignment: Alignment.topRight,
            child: Consumer<WalletProvider>(
              builder: (context, value, child) {
                return ReuseDropDown(
                  initialValue: initialValue,
                  onChanged: onChanged,
                  itemsList: value.listSymbol,
                  style: TextStyle(
                    color: isDarkTheme
                      ? hexaCodeToColor( AppColors.darkSecondaryText)
                      : hexaCodeToColor(AppColors.textColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}