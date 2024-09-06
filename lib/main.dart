import 'package:expensetracker/expenses.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

//usare k nel nome è convenzione per variabili globali
//metodo from seed mi crea una palette di colori da usare per mia app a partire da un dato colore
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
  WidgetsFlutterBinding.ensureInitialized();
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
          titleTextStyle: GoogleFonts.ubuntu(
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
      chipTheme: const ChipThemeData().copyWith(
        selectedColor: kDarkColorScheme.primaryContainer,
      ),
      textTheme:ThemeData(brightness: Brightness.dark).textTheme.copyWith(
        titleLarge: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w600,
            color: kDarkColorScheme.onSecondaryContainer,
            fontSize: 16, 
          ),
          titleSmall: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            color: kDarkColorScheme.onSecondaryContainer,
            fontSize: 14, 
          ),
          bodySmall: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w600,
            color: kDarkColorScheme.onSecondaryContainer,
            fontSize: 14, 
          )
          
        ),
        badgeTheme: BadgeThemeData().copyWith(
          backgroundColor: Colors.red
        )

      
      ),

      //LIGHT MODE
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          titleTextStyle: GoogleFonts.ubuntu(
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
          searchViewTheme: const SearchViewThemeData().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
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
          titleLarge: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            color:kColorScheme.onSecondaryContainer,
            fontSize: 16
          ),
          titleSmall: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w600,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 14, 
          ),
          bodySmall: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w600,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 14, 
          ),
        ),
        chipTheme: const ChipThemeData().copyWith(
        selectedColor: kColorScheme.primaryContainer
      ),     
      badgeTheme: BadgeThemeData().copyWith(
          backgroundColor: kColorScheme.secondaryContainer,
          textColor: Colors.black
        ),
      ),
      
      home: const Expenses(),
      debugShowCheckedModeBanner: false,
      //theme mode usato per dire ad app quale tema applicare dark o light
      themeMode: ThemeMode.system,
    ),
  );
}
