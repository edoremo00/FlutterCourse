import 'package:flutter/material.dart';

enum Category {food,travel,leisure,work,other}

//map
 Map<Category,IconData?> categoryIcons={
  Category.food:Icons.lunch_dining,
  Category.travel:Icons.flight_takeoff,
  Category.leisure:Icons.movie,
  Category.work:Icons.work,
  Category.other:null
};