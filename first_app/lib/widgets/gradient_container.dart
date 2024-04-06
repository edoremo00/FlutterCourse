import 'package:first_app/widgets/dice_roller.dart';
import 'package:flutter/material.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  final List<Color> gradientcolors;
  const GradientContainer({super.key, required this.gradientcolors});
  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: startAlignment,
          end: endAlignment,
          colors: gradientcolors,
        ),
      ),
      child: const Center(
        child: DiceRoller(),
      ),
    );
  }
}
