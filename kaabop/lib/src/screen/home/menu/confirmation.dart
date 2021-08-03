import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/components/component.dart';

import '../../../../index.dart';

class Confirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: "Account",
              color: isDarkTheme
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.whiteColorHexa),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
