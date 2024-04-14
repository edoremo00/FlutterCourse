import 'package:adv_basics/data/questions.dart';
import 'package:adv_basics/models/quiz_summary.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final VoidCallback restartFn;
  final List<String> chosenAnswers;
  ResultsScreen(
      {super.key, required this.restartFn, required this.chosenAnswers});

  // final Map<String,Q> summary={};

  final List<QuizSummary> summary = [];

  List<QuizSummary> populateSummary() {
    for (var i = 0; i < chosenAnswers.length; i++) {
      // summary.addAll({'index':i,'question':questions[i].questiontext,'correctedanswer':questions[i].answers[0]});
      bool isCorrected=chosenAnswers[i]==questions[i].answers[0];
      summary.add(
        QuizSummary(
            index: i + 1,
            question: questions[i].questiontext,
            correctedanswer: questions[i].answers[0],
            isCorrected: isCorrected
        ),
      );
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Text(
          //   "You answered X out of Y questions correctly",
          // ),
          // const SizedBox(
          //   height: 30,
          // ),
          ...populateSummary().map((e) => Text("${e.isCorrected ? "SI" :"NO"}")),
          const Text("list of answers and questions"),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: restartFn,
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }
}
