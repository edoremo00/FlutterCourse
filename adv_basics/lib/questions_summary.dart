import 'package:adv_basics/models/quiz_summary.dart';
import 'package:adv_basics/summary_text_widget.dart';
import 'package:flutter/material.dart';

class QuestionsSummary extends StatelessWidget {
  final List<QuizSummary> answersSummary;
  const QuestionsSummary({super.key, required this.answersSummary});

  Color determineTextColor(QuizSummary answer){
    return answer.isCorrected ? const Color.fromARGB(255, 123, 229, 126) : const Color.fromARGB(255, 240, 120, 112);
  }

  @override
  Widget build(BuildContext context) {
    //uso sizedbox per dare altezza fissa a colonna che senza prende tutto lo spazio che può
    //per rendere tutti scrollabile e non avere overflow uso poi singlechildscrollview
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        child: Column(
          children: answersSummary
              .map(
                (data) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:determineTextColor(data),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SummaryText(textcontent: "${data.index}",textcolor: Colors.black,fontweight: FontWeight.w800,textsize: 12,),
                      // child: Text("${data.index}"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SummaryText(textcolor: const Color.fromARGB(255, 220, 211, 234), textcontent: data.question, textsize: 14),
                            SummaryText(textcolor: determineTextColor(data), textcontent: data.useranswer, textsize: 14),
                            SummaryText(textcolor:  const Color.fromARGB(255, 123, 229, 126), textcontent: data.correctedanswer, textsize: 14),
                          ]),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
