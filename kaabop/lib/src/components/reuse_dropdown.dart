import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../index.dart';

class ReuseDropDown extends StatelessWidget {
  
  final ValueChanged<String> onChanged;
  final Widget icon;
  final String initialValue;
  final TextStyle style;
  final List<String> itemsList;

  const ReuseDropDown({
    this.onChanged,
    this.initialValue,
    this.icon,
    this.style,
    this.itemsList
  });

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Theme(
      data: ThemeData(
        canvasColor: hexaCodeToColor(isDarkTheme ? AppColors.darkCard : AppColors.whiteColorHexa)
      ),
      child: DropdownButton<String>(
        value: initialValue,
        underline: Container(
          color: Colors.blue,
        ),
        style: style,
        icon: icon,
        onChanged: onChanged,
        items: itemsList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value)
          );
        }).toList(),
      ),
    );
  }
}
