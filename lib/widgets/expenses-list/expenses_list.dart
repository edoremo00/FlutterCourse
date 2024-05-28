import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/expenses-list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  const ExpensesList({super.key, required this.expenses});
  @override
  Widget build(BuildContext context) {
    //expanded mi serve perchè flutter non sa quanto fare grande il listview dal momento che è inserito dentro un'altra colonna che occupa tutto lo schermo
    return Expanded(
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) =>
            ExpenseItem(expenseitem: expenses[index]),
      ),
    );
  }
}
