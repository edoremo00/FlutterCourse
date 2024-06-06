import 'package:expensetracker/helpers/expense_rnd_color_manager.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/expenses-list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense exp) onRemoveExpense;

  const ExpensesList({super.key, required this.expenses,required this.onRemoveExpense});

  @override
  Widget build(BuildContext context) {
    //expanded mi serve perchè flutter non sa quanto fare grande il listview dal momento che è inserito dentro un'altra colonna che occupa tutto lo schermo
    return Expanded(
      child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            //keys--> vedi appunti per dettagli
            final rndColor=ExpenseRandomColorManager.getRandomDismissibleBackground(index);
            return Dismissible(
              onDismissed: (direction) {
                onRemoveExpense(expenses[index]);
              },
              background: Container(
                color: rndColor,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete),
                    )
                  ],
                ),
              ),
              key: ValueKey(expenses[index]),
              child: ExpenseItem(expenseitem: expenses[index]),
            );
          }),
    );
  }
}
