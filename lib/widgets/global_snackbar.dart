import 'package:flutter/material.dart';

class GlobalSnackBar{
  final String contentText;
  final SnackBarAction? action;
  final SnackBarBehavior? behavior;
  final Duration duration;
  const GlobalSnackBar({required this.contentText,required this.duration, this.action, this.behavior});
  
   static void show(BuildContext context,GlobalSnackBar snackBar)  {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: snackBar.behavior,
            duration: const Duration(seconds: 3),
            content: Text(snackBar.contentText),
            action: snackBar.action,
          ),
        ); 
  }
 
  static void clearSnackBars(BuildContext ctx){
    ScaffoldMessenger.of(ctx).clearSnackBars();
  }
  
}