import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/expenses-list/expenses_list.dart';
import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget{

  final List<Expense> Function(String? searchText) onExpenseSearch;
  final void Function({Expense? expenseToedit}) onModifyswipeDirection;
  final void Function(Expense exp) onRemoveExpense;
  final String currencySymbol;
  const SearchPage({super.key,required this.onExpenseSearch,required this.currencySymbol,required this.onModifyswipeDirection,required this.onRemoveExpense});

  @override
  State<StatefulWidget> createState() {
    return Searchpagestate();
  } 
}


class Searchpagestate extends State<SearchPage>{
 
 List<Expense> filteredExpenses=[];
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void handleRefresh(){
    // setState(() {
    //   widget.onExpenseSearch(searchController.text);
    // });
    setState(() {
      filteredExpenses=widget.onExpenseSearch(searchController.text);
    });
  }

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      appBar: AppBar(
        actions:   [
          const SizedBox(width: 50,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value){
                      setState(() {
                        filteredExpenses=widget.onExpenseSearch(value);
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search expenses",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5)
                      )
                    ),
                    
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: filteredExpenses.isNotEmpty || searchController.text.isEmpty ?
         Column(children: [
           ExpensesList.filtered(filteredExpenses, widget.currencySymbol, widget.onModifyswipeDirection, widget.onRemoveExpense,handleRefresh)
         ],)
        
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text("No expense found"),
            ),
    );
  }
    
}