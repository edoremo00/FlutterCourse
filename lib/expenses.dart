import 'package:expensetracker/models/filter.dart';
import 'package:expensetracker/models/sorting.dart';
import 'package:expensetracker/widgets/chart/chart.dart';
import 'package:expensetracker/widgets/expenses-list/expenses_list.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/filters.dart';
import 'package:expensetracker/widgets/new_expense.dart';
import 'package:expensetracker/widgets/global_snackbar.dart';
import 'package:expensetracker/widgets/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/category.dart';

enum SortDirection { up, down }

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
  String defaultSortdir = SortDirection.down.name;
  List<Expense>? _filteredExpenses;
  bool isFilteredView = false;
  int? appliedFilterNum;
  Filter? lastfilterObj;

  

  @override
  void initState() {
    super.initState();
    _filteredExpenses = [..._registeredExpenses];
  }

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

  void _openAddExpenseOverlay(
      {Expense? expenseToedit, void Function()? handleSearchRefresh}) {
    //context è resa disponibile da flutter in automatico dato che siamo in una classe che estende state
    //eg statefulwidget
    //context--> metadati ogni widget ha il suo. contiene info sul widget e su sua posizione in widget tree
    //builder è una funzione che ritorna un widget
    //funzione handlesearchrefresh ha valore non null nel caso di modifica da pagine della ricerca ed eseguita per aver i dati aggiornati
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
        onModifyExpense: _modifyExpense,
        existingExpense: expenseToedit,
        currencySymbol: currencySymbol,
        onHandleSearchRefresh: handleSearchRefresh,
      ),
    );
  }

  void _addExpense(Expense newexp) {
    setState(() {
      _registeredExpenses.add(newexp);
      _filteredExpenses?.add(newexp);
    });
  }

  void _removeExpense(Expense exp, {void Function()? handleSearchRefresh}) {
    final expenseIndex = _registeredExpenses.indexOf(exp);
    setState(() {
      _registeredExpenses.remove(exp);
      _filteredExpenses?.remove(exp);
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
          onPressed: () {
            // Undo the expense removal
            setState(() {
              _registeredExpenses.insert(expenseIndex, exp);
              _filteredExpenses?.insert(expenseIndex, exp);
            });
            // Call the refresh callback after undo
            if (handleSearchRefresh != null) {
              handleSearchRefresh();
            }
          },
        ),
      ),
    );
    //call refresh after the delete if we are in the searchpage
    if (handleSearchRefresh != null) {
      handleSearchRefresh();
    }
  }

  void _modifyExpense(Expense edited) {
    final editedExpenseIndex = _registeredExpenses.indexOf(edited);
    if (editedExpenseIndex > -1) {
      setState(() {
        _registeredExpenses[editedExpenseIndex] = edited;
        _filteredExpenses?[editedExpenseIndex] = edited;
      });
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
  }

  List<Expense> _filterExpenses(String? searchtext) {
    if (searchtext == null || searchtext.isEmpty) return List.empty();
    return _registeredExpenses
        .where(
          (element) => element.title.toLowerCase().contains(
                searchtext.toLowerCase(),
              ),
        )
        .toList();
  }

  List<Expense> _filterandSort(Filter? filterObj) {
    if (filterObj?.categories == null && filterObj?.sorting == null) {
      //non filtri nulla e non ordini nulla esco da filteredview
      setState(() {
        isFilteredView=false;
      });
      return _registeredExpenses;
    }
    List<Expense>? result=List.from(_filteredExpenses!);
    //handle category filtering single and multiple
    lastfilterObj=filterObj;
    if(filterObj?.categories!=null){
      result=_filteredExpenses?.where((element) {
       //TODO FIX BUG VEDI POST IT scrivania
        return filterObj!.categories!.any((cat) => cat.name==element.category.name);
      }).toList();
    }
    //check sorting
    if (filterObj?.sorting != null) {
      //handle sort
      result?.sort((a, b) {
        int comparison;
        switch (filterObj?.sorting) {
          case Sorting.date:
            comparison = a.date.compareTo(b.date);
            break;
          case Sorting.price:
            comparison = a.amount.compareTo(b.amount);
            break;
          case Sorting.expensename:
            comparison = a.title.compareTo(b.title);
            break;
          default:
            comparison = 0;
        }
        return filterObj?.sortDirection == SortDirection.up
            ? comparison
            : -comparison;
      });
    }

    setState(() {
      _filteredExpenses=result;
      isFilteredView=true;
      appliedFilterNum=filterObj?.categories?.length;
    });
    return result ?? List.empty();
  }

  void _openFilterExpenseOverlay() {
    //context è resa disponibile da flutter in automatico dato che siamo in una classe che estende state
    //eg statefulwidget
    //context--> metadati ogni widget ha il suo. contiene info sul widget e su sua posizione in widget tree
    //builder è una funzione che ritorna un widget
    //funzione handlesearchrefresh ha valore non null nel caso di modifica da pagine della ricerca ed eseguita per aver i dati aggiornati
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (ctx) => FiltersWidget(
              onFilterandSort: _filterandSort,
              lastAppliedfilterObj: lastfilterObj,
            ));
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
        actions: [
          //TODO IMPLEMENT search and filters
          //per searchbar: https://api.flutter.dev/flutter/material/SearchBar-class.html
          // SearchAnchor(
          //   searchController: controller,
          //   isFullScreen: false,
          //   viewConstraints: BoxConstraints.expand(width: double.infinity,height: 150),
          //   viewHintText:"search expenses" ,
          //   builder: (context, controller) => IconButton(
          //     onPressed: () {
          //       controller.openView();
          //     },
          //     icon: const Icon(Icons.search),
          //   ),
          //   suggestionsBuilder: (context, controller) {
          //     return List.empty();
          //   },
          // ),
          IconButton(
            onPressed: () {
              // setState(() {
              //   isFilteredView=false;
              // });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchPage(
                    onExpenseSearch: _filterExpenses,
                    currencySymbol: currencySymbol!,
                    onModifyswipeDirection: _openAddExpenseOverlay,
                    onRemoveExpense: _removeExpense,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
          GestureDetector(
            onTap: _openFilterExpenseOverlay,
            child: Badge(
              isLabelVisible: (appliedFilterNum ?? 0)>0,
              label:  Text("$appliedFilterNum"),
              offset: const Offset(-5, 10),
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: _openFilterExpenseOverlay,
                icon: const Icon(Icons.filter_list),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          //spacer prende quanto spazio possibile e lo divide equamente tra i due widget qua presenti
          //conditonal list per evitare di fare un expanded che wrappa colonna ecc
          if (_registeredExpenses.isEmpty) ...[
            const Spacer(),
            const Center(
              child: Text("No expenses found. Start adding some!"),
            ),
            CircleAvatar(
              child: IconButton(
                  onPressed: _openAddExpenseOverlay,
                  icon: const Icon(Icons.add)),
            ),
            const Spacer()
          ] else if (isFilteredView && _filteredExpenses!.isEmpty) ...[
            const Center(
              child: Text("No result found for this filters"),
            )
          ] else ...[
            const SizedBox(
              height: 12,
            ),
            //mostra grafico solo se non sono con filtri oppure se categorie in filtri sono più di una e se risultati sono da 2 in su
            // uso numero usato nel badge dei filtri applicati per il check
            if (!isFilteredView ||
                (isFilteredView &&
                    (appliedFilterNum ?? 0) > 1 &&
                    (_filteredExpenses?.length ?? 0) >= 2)) ...[
              Text("Chart", style: Theme.of(context).textTheme.titleSmall),
              Chart(expenses: _registeredExpenses),
            ],
            Text(
              "My Expenses",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ExpensesList(
              expenses:
                  isFilteredView ? _filteredExpenses! : _registeredExpenses,
              onRemoveExpense: _removeExpense,
              onModifyswipeDirection: _openAddExpenseOverlay,
              currencySymbol: currencySymbol!,
            ),
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpenseOverlay,
        label: const Text("New Expense"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
