import 'package:adv_basics/questions_screen.dart';
import 'package:adv_basics/start_screen.dart';
import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<StatefulWidget> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  //capire meglio late in questo caso
  // late Widget activeScreen=StartScreen(switchscreenFn: switchScreen);

  // @override
  // void initState() {
  //   super.initState();
  //   //funzione la posso passare solo qui a startscreen in quando sua inizializzazione(classe quiz state) è già avvenuta
  //posso fare stessa cosa con late
  //   activeScreen=StartScreen(switchscreenFn: switchScreen);
  // }
  String activeScreen = "start-screen";
  final List<String> selectedAnswers=[];
  void switchScreen() {
    setState(() {
      activeScreen = "questions-screen";
    });
  }

  void addSelectedAnswer(String answer){
    selectedAnswers.add(answer);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 78, 13, 151),
              Color.fromARGB(255, 107, 15, 168)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          //siccome startscreen contiene center come unico figlio esso prova a centrare orrizzontalmente e verticalmente
          //il testo e per farlo si espande al massimo che può. ciò fa in modo che lo sfondo sia visibile ovunque e il testo ovvimente sia centrato
          //container occupa il minimo spazio disponibile ( ciò vale senza colonna ora presente)
          child: activeScreen == "start-screen"
              ? StartScreen(switchscreenFn: switchScreen)
              : QuestionScreen(onSelectAnswer: addSelectedAnswer,),
        ),
      ),
    );
  }
}
