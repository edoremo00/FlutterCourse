import 'package:expensetracker/expenses.dart';
import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/models/sorting.dart';

class Filter{
   List<Category>? categories;
   Sorting? sorting;
   SortDirection? sortDirection;
   ExpenseType? expenseType;
   Filter({this.categories,this.sorting,this.sortDirection,this.expenseType});

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is Filter &&
//         categories == other.categories &&
//         sorting == other.sorting &&
//         sortDirection == other.sortDirection;
//   }

//  // If input bits are the same, then the output will be false(0) else true(1).
//  // vedi su chat gpt spiegazione
//  //mi servirà per filtro dal momento che creo un set e set per confrontare due oggetti usa == come operatore
//  //in questo modo do a set o a chiunque comare due istanze filter di comparle in base ai lori campu
//   @override
//   int get hashCode {
//     return (categories?.hashCode ?? 0) ^ (sorting?.hashCode ?? 0) ^ (sortDirection?.hashCode ?? 0);
//   }
}