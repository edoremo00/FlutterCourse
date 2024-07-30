import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/expenses-list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  void Function()? handleSearchRefresh;
  final void Function(Expense exp, {void Function()? handleSearchRefresh}) onRemoveExpense;
  final void Function({Expense? expenseToedit,void Function()? handleSearchRefresh}) onModifyswipeDirection;
  String currencySymbol;

  ExpensesList({super.key, required this.expenses,required this.onRemoveExpense,required this.onModifyswipeDirection,required this.currencySymbol});

 //costruttore usato per mostrare risultati ricerca
  ExpensesList.filtered(List<Expense> filteredExpenses,this.currencySymbol,this.onModifyswipeDirection,this.onRemoveExpense,this.handleSearchRefresh, {super.key}):expenses=filteredExpenses;

  @override
  Widget build(BuildContext context) {
    //expanded mi serve perchè flutter non sa quanto fare grande il listview dal momento che è inserito dentro un'altra colonna che occupa tutto lo schermo
    return Expanded(
      child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            //keys--> vedi appunti per dettagli
            //NOT USED ANYMORE
            // final rndColor=ExpenseRandomColorManager.getRandomDismissibleBackground(index);
            return Dismissible(
              dismissThresholds: const {DismissDirection.startToEnd:0.1,DismissDirection.endToStart:0.1},
              onDismissed: (direction) {
                onRemoveExpense(expenses[index],handleSearchRefresh:handleSearchRefresh);

              },
              confirmDismiss: (direction) async{
                //modify
                if(direction==DismissDirection.endToStart){
                  //open modal to edit
                  //display updated info also in the searchpage (if we are in that page) in this case handesearchpage function is not null
                  onModifyswipeDirection(expenseToedit:expenses[index],handleSearchRefresh:handleSearchRefresh);
                  return false;
                  
                }
                //delete
                return true;
              },
              //delete
              background: Container(
                margin:EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
                color: Theme.of(context).colorScheme.error,
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
                color: Theme.of(context).colorScheme.secondaryContainer,
                margin:EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
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
