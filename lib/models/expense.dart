import 'package:expensetracker/models/category.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

final formatter = DateFormat("dd/MM/y", "it_IT");

class Expense {
  final String id;
  String title;
  double amount;
  DateTime date;
  Category category;

//https://dart.dev/language/constructors#use-an-initializer-list questa feature di dart mi permette di
//inizializzare l'id prima che il costruttore venga eseguito
  Expense(
      {required this.title,
      required this.amount,
      required DateTime expdate,
      required this.category})
      : id = uuid.v4(),
        date = expdate;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});
  final Category category;
  final List<Expense> expenses;

//additional constructor function
  // ExpenseBucket.forCategory({required this.expenses,required this.category}){
  //  expenses= expenses.where((element) => element.category==category).toList();
  //  expenses=[];
  // }

  //NOTA: USIAMO LIST INITIALIZER IN QUANTO CI PERMETTE DI MANTENERE LISTA FINAL
  //E QUINDI MANTENERE LA SUA IMMUTABILITà. METODO QUA SOPRA INVECE PER QUANTO
  //RAGGIUNGA IL MEDESIMO SCOPO MI PERMETTE NEL CODICE DI RIASSEGNARE LA LISTA ANCHE A QUALCOS'ALTRO
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((element) => element.category == category)
            .toList();

  double get totalExpenses {
    //o con for in
    // double sum=0;
    // for(var expense in expenses){
    //   return sum+=expense.amount;
    // }
    // return sum;

    //oppure con fold che è equivalente a metodo reduce in JS
    return expenses.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }
}
