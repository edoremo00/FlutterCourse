import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';



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
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //metodo build esegguito in automatico da flutter quando cambio rotazione schermo
   final width=MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      //altro modo per creare ui responsive in base a rotazione schermo è usare orientationbuilder
      body: OrientationBuilder(
        builder: ((context, orientation) {
          return orientation.name == "landscape"
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  //widget chart ha container con larghezza massima infinito i suoi limiti sono imposti solo dal parent widget che lo contiene.
      //     //esendo che il parent fa la stessa cosa il container non ha limiti di larghezza.
      //     //ciò causa errore solo in riga in quanto la larghezza non è impostata e non ha limiti 
      // in caso di colonna invece abbiamo un limite
                    // Expanded(
                    //   child: Chart(expenses: _registeredExpenses),
                    // ),
                    // Expanded(child: mainContent)
                    Expanded(child: Chart(expenses: _registeredExpenses),),
                    Expanded(child: mainContent)
                  ],
                )
              : Column(children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(child: mainContent)
                  //mainContent
                ]);
        }),
      ),
      // body: width < 600 ? Column(
      //   children: [
      //     Chart(expenses: _registeredExpenses),
      //     Expanded(
      //       child: mainContent,
      //     ),
      //   ],
      // ) : Row(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     //widget chart ha container con larghezza massima infinito i suoi limiti sono imposti solo dal parent widget che lo contiene.
      //     //esendo che il parent fa la stessa cosa il container non ha limiti di larghezza.
      //     //ciò causa errore perchè flutter non sa come far vedere l'UI dal 
      //     //momento che entrambi vogliono occupare quanto più spazio possibile
      //      Expanded(child: Chart(expenses: _registeredExpenses)),
      //      Expanded(child: mainContent)
      //     // Expanded(
      //     //   child: mainContent,
      //     // ),
      //   ],
      // ),
    );
  }
}
