
import 'package:expensetracker/models/category.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';


const uuid=Uuid();

final formatter=DateFormat("d/MM/y","it_IT");



class Expense{
  final String id;
  String title;
  double amount;
  DateTime date;
  Category category;

//https://dart.dev/language/constructors#use-an-initializer-list questa feature di dart mi permette di 
//inizializzare l'id prima che il costruttore venga eseguito
  Expense({required this.title,required this.amount,required DateTime expdate,required this.category}) :id=uuid.v4(),date=expdate;

  String get formattedDate{
    return formatter.format(date);
  }
}