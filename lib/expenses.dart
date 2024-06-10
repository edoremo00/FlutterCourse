import 'package:expensetracker/widgets/expenses-list/expenses_list.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/new_expense.dart';
import 'package:expensetracker/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/category.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Flutter Course",
      amount: 9.99,
      expdate: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Cinema",
      amount: 16.99,
      expdate: DateTime.now(),
      category: Category.leisure,
    ),
    
  ];
  String? currencySymbol;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    retrieveCurrencySymbol();
  }

    void retrieveCurrencySymbol() {
    final locale = View.of(context).platformDispatcher.locale.toLanguageTag();
    final formatted = NumberFormat.simpleCurrency(locale: locale);
    if (formatted.currencySymbol != currencySymbol) {
      setState(() {
        currencySymbol = formatted.currencySymbol;
      });
    }
  }

  void _openAddExpenseOverlay({Expense? expenseToedit}){

    //context è resa disponibile da flutter in automatico dato che siamo in una classe che estende state
    //eg statefulwidget
    //context--> metadati ogni widget ha il suo. contiene info sul widget e su sua posizione in widget tree
    //builder è una funzione che ritorna un widget
   showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense,onModifyExpense: _modifyExpense,existingExpense: expenseToedit,currencySymbol: currencySymbol,),
    );
  }

  void _addExpense(Expense newexp){
    setState(() {
      _registeredExpenses.add(newexp);
    });
  }

  void _removeExpense(Expense exp){
    final expenseIndex= _registeredExpenses.indexOf(exp);
    setState(() {
      _registeredExpenses.remove(exp);
    });
    GlobalSnackBar.clearSnackBars(context);
    GlobalSnackBar.show(
      context,
      GlobalSnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        contentText: "Expense Deleted",
        action: SnackBarAction(
          label: "Undo",
          onPressed: () => setState(() {
            _registeredExpenses.insert(expenseIndex, exp);
          }),
        ),
      ),
    );
  }

  
  void _modifyExpense(Expense edited){
   final editedExpenseIndex=_registeredExpenses.indexOf(edited);
   if(editedExpenseIndex>-1){
     setState(() {
      _registeredExpenses[editedExpenseIndex]=edited;
     });
   }

   GlobalSnackBar.clearSnackBars(context);
    GlobalSnackBar.show(
      context,
      const GlobalSnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        contentText: "Expense Updated",
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Widget mainContent = _registeredExpenses.isNotEmpty
    //     ? ExpensesList(
    //         expenses: _registeredExpenses, onRemoveExpense: _removeExpense)
    //     : const Center(
    //         child: Text("No expenses found. Start adding some!"),
    //       );
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     onPressed: _openAddExpenseOverlay,
        //     icon: const Icon(Icons.add),
        //   )
        // ],
        title: const Text("Expense Tracker"),
      ),
      body: Column(
        children: [
          const Text("Chart"),
          //spacer prende quanto spazio possibile e lo divide equamente tra i due widget qua presenti
          //conditonal list per evitare di fare un expanded che wrappa colonna ecc
          if(_registeredExpenses.isEmpty)...[
            const Spacer(),
            const Center(
              child: Text("No expenses found. Start adding some!"),
            ),
             CircleAvatar(child: IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),),
            const Spacer()
          ]else ...[
             ExpensesList(
              expenses: _registeredExpenses, onRemoveExpense: _removeExpense,onModifyswipeDirection: _openAddExpenseOverlay,currencySymbol: currencySymbol!,),
          ]
          
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _openAddExpenseOverlay, label: const Text("New Expense"),icon: const Icon(Icons.add),),
    );
  }
}
