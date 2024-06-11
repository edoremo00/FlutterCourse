import 'package:expensetracker/helpers/expense_rnd_color_manager.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/expenses-list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense exp) onRemoveExpense;
  final void Function({Expense? expenseToedit}) onModifyswipeDirection;
  String currencySymbol;

  ExpensesList({super.key, required this.expenses,required this.onRemoveExpense,required this.onModifyswipeDirection,required this.currencySymbol});

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
              dismissThresholds: const {DismissDirection.startToEnd:0.1,DismissDirection.endToStart:0.1},
              onDismissed: (direction) {
                onRemoveExpense(expenses[index]);
              },
              confirmDismiss: (direction) async{
                //modify
                if(direction==DismissDirection.endToStart){
                  //open modal to edit
                  onModifyswipeDirection(expenseToedit:expenses[index]);
                  return false;
                  
                }
                //delete
                return true;
              },
              //delete
              background: Container(
                color: rndColor.primary,
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.delete),
                  ),
                ),
              
              ),
              //edit
              secondaryBackground: Container(
                color: rndColor.secondary,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.edit),
                      ),
                )
              ),
              key: ValueKey(expenses[index]),
              child: ExpenseItem(expenseitem: expenses[index],currencySymbol: currencySymbol,),
            );
          }),
    );
  }
}
