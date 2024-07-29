
import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/expenses-list/expenses_list.dart';
import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget{

  final List<Expense> Function(String? searchText) onExpenseSearch;
  const SearchPage({super.key,required this.onExpenseSearch});

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
      // body: ExpensesList.filtered(filteredExpenses,"",""),
      body: filteredExpenses.isNotEmpty || searchController.text.isEmpty ? ListView.separated(
          itemBuilder: (ctx, index) => ListTile(
                title: Text(filteredExpenses[index].title),
                subtitle: Text(filteredExpenses[index].amount.toString()),
                trailing: Icon(categoryIcons[filteredExpenses[index].category]),
              ),
          separatorBuilder: (ctx, index) => const Divider(),
          itemCount: filteredExpenses.length) : const Padding(padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),child: Text("No expense found"),),
    );
  }
    
}