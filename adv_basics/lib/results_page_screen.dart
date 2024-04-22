import 'package:adv_basics/data/questions.dart';
import 'package:adv_basics/models/quiz_summary.dart';
import 'package:adv_basics/questions_summary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsScreen extends StatelessWidget {
  final VoidCallback restartFn;
  final List<String> chosenAnswers;
  ResultsScreen(
      {super.key, required this.restartFn, required this.chosenAnswers});


  final List<QuizSummary> summary = [];

  List<QuizSummary> populateSummary() {
    for (var i = 0; i < chosenAnswers.length; i++) {
      // summary.addAll({'index':i,'question':questions[i].questiontext,'correctedanswer':questions[i].answers[0]});
      bool isCorrected = chosenAnswers[i] == questions[i].answers[0];
      summary.add(
        QuizSummary(
            index: i + 1,
            question: questions[i].questiontext,
            correctedanswer: questions[i].answers[0],
            useranswer: chosenAnswers[i],
            isCorrected: isCorrected),
      );
    }
    return summary;
  }

  int getCorrectedAnswerslength() {
    return summary.where((answer) => answer.isCorrected).length;
  }

  @override
  Widget build(BuildContext context) {
    final int numTotalQuestions = questions.length;
    final List<QuizSummary> answersSummarydata = populateSummary();
    final int numcorrectAnswers = getCorrectedAnswerslength();
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You answered $numcorrectAnswers out of $numTotalQuestions questions correctly!",
            style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: QuestionsSummary(answersSummary: answersSummarydata),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton.icon(
            onPressed: restartFn,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white
            ),
            icon: const Icon(
              Icons.refresh
            ),
            label: const Text(
              "Restart Quiz",
            ),
          )
        ],
      ),
    );
  }
}
