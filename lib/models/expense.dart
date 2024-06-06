
import 'package:expensetracker/models/category.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';


const uuid=Uuid();

final formatter=DateFormat("d/MM/y","it_IT");



class Expense{
  final String id;
  final String title;
  final double amount;
  final DateTime _date;
  final Category category;

//https://dart.dev/language/constructors#use-an-initializer-list questa feature di dart mi permette di 
//inizializzare l'id prima che il costruttore venga eseguito
  Expense({required this.title,required this.amount,required DateTime date,required this.category}) :id=uuid.v4(),_date=date;

  String get formattedDate{
    return formatter.format(_date);
  }
}