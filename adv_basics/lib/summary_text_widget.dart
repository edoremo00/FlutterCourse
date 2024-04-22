import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryText extends StatelessWidget{
  final String textcontent;
  final Color textcolor;
  final double textsize;
  final FontWeight? fontweight;

  const SummaryText({super.key,required this.textcolor,required this.textcontent,required this.textsize,this.fontweight});
  @override
  Widget build(BuildContext context){
    return Text(
      textcontent,
      style: GoogleFonts.lato(
        color:textcolor,
        fontSize:textsize,
        fontWeight:fontweight
      ),
    );
  }
}