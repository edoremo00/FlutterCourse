import 'package:adv_basics/quiz.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // return ResultsScreen();
    return const Quiz();
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Scaffold(
    //     body: Container(
    //       decoration: const BoxDecoration(
    //         gradient: LinearGradient(colors: [
    //           Color.fromARGB(255, 78, 13, 151),
    //           Color.fromARGB(255, 107, 15, 168)
    //         ], begin: Alignment.topLeft, end: Alignment.bottomRight),
    //       ),
    //       //siccome startscreen contiene center come unico figlio esso prova a centrare orrizzontalmente e verticalmente
    //       //il testo e per farlo si espande al massimo che può. ciò fa in modo che lo sfondo sia visibile ovunque e il testo ovvimente sia centrato
    //       //container occupa il minimo spazio disponibile
    //       child: const StartScreen(),
          // child: Center(child: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Image.asset("assets/images/quiz-logo.png",width: 300,color: Color.fromARGB(255, 141, 110, 194),),
          //     const SizedBox(height: 80,),
          //     const Text("Learn Flutter the fun way!",style: TextStyle(color:  Color.fromARGB(255, 141, 110, 194),fontSize: 28,),),
          //     ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.arrow_forward), label: Text("Get Started"),style: ButtonStyle(),)
          //   ],
          // ),),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Center(
          //       child: Image.asset(
          //         "assets/images/quiz-logo.png",
          //         width: 300,
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 40,
          //     ),
          //     const Text(
          //       "Learn Flutter the fun way!",
          //       style: TextStyle(color: Colors.white, fontSize: 28),
          //     )
          //   ],
          // ),

  }
}
