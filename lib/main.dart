import 'package:expensetracker/expenses.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Expenses(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
