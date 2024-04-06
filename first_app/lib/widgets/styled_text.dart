import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  const StyledText({super.key, required this.text, this.textColor=Colors.white, this.fontSize});

  @override
  Widget build(BuildContext context) {
   return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
}
