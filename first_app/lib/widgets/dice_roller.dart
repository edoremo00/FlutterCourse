import 'dart:math';

import 'package:first_app/widgets/styled_text.dart';
import 'package:flutter/material.dart';

final randomGenerator=Random();
class DiceRoller extends StatefulWidget {
  //widget stateful non hanno override metodo di build

  const DiceRoller({super.key});
  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

//convenzione di iniziare con _ significa che classe è privata
class _DiceRollerState extends State<DiceRoller> {
  var currentDiceRoll = 2;
  
  void rollDice() {
    setState(() {
      currentDiceRoll=randomGenerator.nextInt(6)+1; //numeri tra 1 e 6 + 1 serve perchè il massimo 6 è escluso
      //senza +1 mi farebbe da 0 a 5
    });
   
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/dice-$currentDiceRoll.png",
          width: 200,
        ),
        const SizedBox(
          width: 20,
        ),
        TextButton(
          onPressed: rollDice,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 28),
          ),
          child: const StyledText(
            text: "Roll Dice",
            fontSize: 28,
          ),
        )
      ],
    );
  }
}
