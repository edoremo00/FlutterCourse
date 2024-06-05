import 'dart:math';
import 'package:flutter/material.dart';

class ExpenseRandomColorManager {
  static final List<Color> _randomcolors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];

  static final Map<int, Color> _expenseColors = {};

  static Color getRandomDismissibleBackground(int id) {
    if (!_expenseColors.containsKey(id)) {
      _expenseColors[id] =
          _randomcolors[Random().nextInt(_randomcolors.length)];
    }
    return _expenseColors[id]!;
  }
}
