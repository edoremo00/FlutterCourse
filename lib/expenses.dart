import 'package:expensetracker/widgets/expenses-list/expenses_list.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

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
    // Expense(
    //   title: "Flutter Course",
    //   amount: 9.99,
    //   date: DateTime.now(),
    //   category: Category.work,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),
    // Expense(
    //   title: "Cinema",
    //   amount: 16.99,
    //   date: DateTime.now(),
    //   category: Category.leisure,
    // ),

  ];

  void _openAddExpenseOverlay(){

    //context è resa disponibile da flutter in automatico dato che siamo in una classe che estende state
    //eg statefulwidget
    //context--> metadati ogni widget ha il suo. contiene info sul widget e su sua posizione in widget tree
    //builder è una funzione che ritorna un widget
   showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense,),
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
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(label: "Undo",onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, exp);
          });
        },)
      ),
    );
  }

  //TODO implement modify expense and change dismissible to handle it
  void _modifyExpense(Expense old){

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
              expenses: _registeredExpenses, onRemoveExpense: _removeExpense),
          ]
          
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _openAddExpenseOverlay, label: const Text("New Expense"),icon: const Icon(Icons.add),),
    );
  }
}
