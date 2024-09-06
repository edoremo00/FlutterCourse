import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expenseitem;
  String currencySymbol;
  ExpenseItem(
      {super.key, required this.expenseitem, required this.currencySymbol});
  @override
  Widget build(BuildContext context) {
    return Card(
      // color: expenseTypes[expenseitem.expenseType]!.shade400,
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(expenseitem.title,style: Theme.of(context).textTheme.titleLarge,),
      //       Icon(categoryIcons[expenseitem.category]),
      //       const SizedBox(
      //         height: 4,
      //       ),
      //       Row(
      //         children: [
      //           Text(
      //            "$currencySymbol${expenseitem.amount.toStringAsFixed(2)}"
      //           ),
      //           const Spacer(),
      //           // Icon(categoryIcons[expenseitem.category]),
      //           const SizedBox(width: 5,),
      //           Text(expenseitem.formattedDate)
      //         ],
      //       )
      //     ],
      //   ),
      // ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(expenseitem.title),
                Icon(categoryIcons[expenseitem.category]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$currencySymbol${expenseitem.amount.toStringAsFixed(2)}"),
                Text(expenseitem.formattedDate)
              ],
            )
          ],
        ),
      ),
    );
  }
}
