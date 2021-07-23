import 'package:flutter/material.dart';

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
    return DropdownButton<String>(
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
          child: Text(value),
        );
      }).toList(),
    );
  }
}
