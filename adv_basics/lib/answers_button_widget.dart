import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerButton extends StatelessWidget {
  final String answerText;
  // final void Function() onpressedfn;
  //scrivere void Function() è stessa cosa di VoidCallback
  //VoidCallback è typedef di void Function()
  final VoidCallback onPressedfn;
  const AnswerButton(
      {super.key, required this.answerText, required this.onPressedfn});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedfn,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 33, 1, 95),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        answerText,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(),
      ),
    );
  }
}
