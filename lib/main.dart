import 'package:expensetracker/expenses.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

//usare k nel nome è convenzione per variabili globali
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
  error: Colors.redAccent,
);

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 99, 125),
  //brightness dark serve per dire di geneerare seed colori per lo scuro defualt è chiaro
  brightness: Brightness.dark,
  error: Colors.redAccent.shade400,
);

void main() {
  initializeDateFormatting();
  runApp(
    MaterialApp(
      //dark mode
      darkTheme: ThemeData.dark().copyWith( // dark() no longer takes any arguments
      colorScheme: kDarkColorScheme,
      cardTheme: const CardTheme().copyWith(
      color: kDarkColorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3.5,
      ),
      appBarTheme: const AppBarTheme().copyWith(
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.elliptical(25, 15),
                ),
              ),
            elevation: 4
          ),
      //circleavatar theming for dark mode
      primaryColorLight: kDarkColorScheme.inversePrimary,
      textTheme:ThemeData(brightness: Brightness.dark).textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color:kDarkColorScheme.onSecondaryContainer,
            fontSize: 16
          ),
        ),
      
      ),

      //LIGHT MODE
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.elliptical(25, 15),
                ),
              ),
            shadowColor: const Color.fromARGB(255, 186, 184, 184),
            elevation: 4
          ),
        cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3.5),
        textButtonTheme: TextButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.secondaryContainer,
            ),
        ),
        textTheme:ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color:kColorScheme.onSecondaryContainer,
            fontSize: 16
          ),
        ),
      ),
      home: const Expenses(),
      debugShowCheckedModeBanner: false,
      //theme mode usato per dire ad app quale tema applicare dark o light
      themeMode: ThemeMode.system,
    ),
  );
}
