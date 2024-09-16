import 'package:expensetracker/models/filter.dart';
import 'package:expensetracker/models/sorting.dart';
import 'package:expensetracker/widgets/chart/chart.dart';
import 'package:expensetracker/widgets/expenses-list/expense_type_filter.dart';
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
      expenseType: ExpenseType.expense,
      title: "Flutter Course",
      amount: 9.99,
      expdate: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      expenseType: ExpenseType.expense,
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
  ExpenseType? appliedExpensetypeFilter;
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
      if (isFilteredView && appliedFilterNum! > 0) {
        _registeredExpenses.add(newexp);
        _filteredExpenses?.add(newexp);
      } else {
        isFilteredView = false;
        _registeredExpenses.add(newexp);
      }
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
    // bool shouldRefreshfilters = false;
    if (editedExpenseIndex > -1) {
      // if (_registeredExpenses[editedExpenseIndex].category.name !=
      //     edited.category.name || _registeredExpenses[editedExpenseIndex].expenseType.index !=edited.expenseType.index) {
      //   //user changed the category or the type of the expense eg: expense--> income
      //   shouldRefreshfilters = true;
      // }
      setState(() {
        _registeredExpenses[editedExpenseIndex] = edited;
        // _filteredExpenses?[editedExpenseIndex] = edited;
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
      // //redo the filtering after update in case user changed info in particular the category
      // if (shouldRefreshfilters) {
      //   _refreshFilters();
      // }
    }
  }

//metodo non più necessario aggiornamento filtri già gestito prima
  void _refreshFilters() {
    var filter = Filter();
    if (lastfilterObj?.categories != null) {
      if (lastfilterObj!.categories!.isNotEmpty) {
        filter.categories = lastfilterObj!.categories;
      } else {
        filter.categories = List.empty();
      }
    }
    if (lastfilterObj?.sorting != null) {
      filter.sorting = lastfilterObj!.sorting;
    }
    if (lastfilterObj?.sortDirection != null) {
      filter.sortDirection = lastfilterObj!.sortDirection;
    }
    _filterandSort(filterObj: filter);
  }

//METODO NON PIù USATO. tutto inglobato in filterandsort
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

  List<Expense> _filterandSort({Filter? filterObj,String? searchText}) {
    if (filterObj?.categories == null && filterObj?.sorting == null && (searchText==null|| searchText.isEmpty) && (filterObj?.expenseType==null)) {
      //non filtri nulla e non ordini nulla esco da filteredview
      setState(() {
        isFilteredView = false;
      });
      return _registeredExpenses;
    }
    List<Expense> result = List.from(_registeredExpenses);
    //handle category filtering single and multiple
    lastfilterObj = filterObj;
    if (filterObj?.categories != null) {
      result = filterObj!.categories!.isNotEmpty
          ? (result.where((element) {
              return filterObj!.categories!
                  .any((cat) => cat.name == element.category.name);
            }).toList())
          : _registeredExpenses;
      // result=_registeredExpenses.where((element) {
      //   return filterObj!.categories!.any((cat) => cat.name==element.category.name);
      // }).toList();
    }
    //handle search by text
    if (searchText != null && searchText.isNotEmpty) {
      result = result
          .where(
            (element) => element.title.toLowerCase().contains(
                  searchText.toLowerCase(),
                ),
          )
          .toList();
    }

    //handle search by expensetype
    if(filterObj?.expenseType!=null){
      result = result
          .where((element) => element.expenseType == filterObj?.expenseType)
          .toList();
    }
    
    //check sorting
    if (filterObj?.sorting != null) {
      //handle sort
      result.sort((a, b) {
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
      _filteredExpenses = result;
      isFilteredView = true;
      appliedFilterNum = filterObj?.categories?.length;
    });
    return result;
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
                    onExpenseSearch: _filterandSort,
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
              backgroundColor: Theme.of(context).badgeTheme.backgroundColor,
              textColor: Theme.of(context).badgeTheme.textColor,
              isLabelVisible: (appliedFilterNum ?? 0) > 0,
              label: Text(
                "$appliedFilterNum",
              ),
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
            const SizedBox(
              height: 12,
            ),
            Text("Chart", style: Theme.of(context).textTheme.titleSmall),
            Chart(expenses: _registeredExpenses),
            Text(
              "My Expenses",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...expenseTypes.entries.map(
                  (e) => ExpenseTypeFilter(
                    label: Text(
                      e.key.name,
                      style: TextStyle(
                          color: appliedExpensetypeFilter == e.key
                              ? e.value
                              : Theme.of(context).textTheme.bodySmall?.color),
                    ),
                    borderColor: appliedExpensetypeFilter == e.key
                        ? e.value
                        : Theme.of(context).cardTheme.color!,
                    selected: appliedExpensetypeFilter == e.key,
                    onSelected: (_) {
                      setState(() {
                        //gestione deselect filtro
                        if (appliedExpensetypeFilter != null &&
                            e.key == appliedExpensetypeFilter) {
                          appliedExpensetypeFilter = null;
                        } else {
                          appliedExpensetypeFilter = e.key;
                        }
                        //do the filtering
                        _filterandSort(
                          filterObj: Filter(
                              categories: lastfilterObj?.categories,
                              expenseType: appliedExpensetypeFilter,
                              sortDirection: lastfilterObj?.sortDirection,
                              sorting: lastfilterObj?.sorting),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const Center(
              child: Text("No result found for this filters"),
            ),
            
          ] else ...[
            const SizedBox(
              height: 12,
            ),
            //mostra grafico solo se non sono con filtri oppure se categorie in filtri sono più di una 
            // uso numero usato nel badge dei filtri applicati per il check
            if (!isFilteredView ||
                (isFilteredView && (_filteredExpenses?.length ?? 0) >= 1)) ...[
              Text("Chart", style: Theme.of(context).textTheme.titleSmall),
              Chart(expenses: _registeredExpenses),
            ],
            Text(
              "My Expenses",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...expenseTypes.entries.map(
                  (e) => ExpenseTypeFilter(
                    label: Text(
                      e.key.name,
                      style: TextStyle(
                          color: appliedExpensetypeFilter == e.key
                              ? e.value
                              : Theme.of(context).textTheme.bodySmall?.color),
                    ),
                    borderColor: appliedExpensetypeFilter == e.key
                        ? e.value
                        : Theme.of(context).cardTheme.color!,
                    selected: appliedExpensetypeFilter == e.key,
                    onSelected: (_) {
                      setState(() {
                        //gestione deselect filtro
                        if (appliedExpensetypeFilter != null &&
                            e.key == appliedExpensetypeFilter) {
                          appliedExpensetypeFilter = null;
                        } else {
                          appliedExpensetypeFilter = e.key;
                        }
                        //do the filtering
                        _filterandSort(
                          filterObj: Filter(
                            categories: lastfilterObj?.categories,
                            expenseType: appliedExpensetypeFilter,
                            sortDirection: lastfilterObj?.sortDirection,
                            sorting: lastfilterObj?.sorting
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
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
