import 'dart:math';
import 'package:flutter/material.dart';

class ExpenseRandomColorManager {
  static final List<Color> _randomcolors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];

  static final Map<int, Dismissiblecolor> _expenseColors = {};

  static Dismissiblecolor getRandomDismissibleBackground(int id) {
    if (!_expenseColors.containsKey(id)) {
    Color primaryColor=_randomcolors[Random().nextInt(_randomcolors.length)];
    Color? secondaryColor;
     do {
      secondaryColor=_randomcolors[Random().nextInt(_randomcolors.length)];
     } while (primaryColor==secondaryColor);

     _expenseColors[id]=Dismissiblecolor(primary: primaryColor,secondary: secondaryColor);
    }
    return _expenseColors[id]!;
  }
}

class Dismissiblecolor{
  final Color primary;
  Color? secondary;

  Dismissiblecolor({required this.primary,this.secondary});
}
