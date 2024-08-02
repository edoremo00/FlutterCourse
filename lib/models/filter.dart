import 'package:expensetracker/expenses.dart';
import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/sorting.dart';

class Filter{
   Category? category;
   Sorting? sorting;
   SortDirection? sortDirection;

   Filter({this.category,this.sorting,this.sortDirection});
}