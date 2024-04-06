
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback switchscreenFn;
  const StartScreen({super.key,required this.switchscreenFn});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/quiz-logo.png",
            width: 300,
            color: const Color.fromARGB(150, 255, 255, 255),
          ),
          const SizedBox(
            height: 80,
          ),
          Text(
            "Learn Flutter the fun way!",
            style: GoogleFonts.lato(
              color:const Color.fromARGB(255, 141, 110, 194),
              fontSize:24
            ),
            // style: TextStyle(
            //   color: Color.fromARGB(255, 141, 110, 194),
            //   fontSize: 24,
            // ),
          ),
          const SizedBox(
            height: 30,
          ),
          OutlinedButton.icon(
            onPressed: switchscreenFn,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(),
            ),
            icon: const Icon(Icons.arrow_right_alt),
            label: Text("Start quiz",style: GoogleFonts.lato(),),
          )
        ],
      ),
    );
  }
}
