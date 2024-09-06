import 'package:flutter/material.dart';

class ExpenseTypeFilter extends StatelessWidget{
  final void Function(bool) onSelected;
  final bool selected;
  final Color? selectedShadowcolor;
  final Color borderColor;
  final Widget label;
  const ExpenseTypeFilter({super.key,required this.onSelected,required this.selected,required this.label,required this.borderColor, this.selectedShadowcolor});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      showCheckmark: false,
      label: label,
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor, // Border color
          width: 2.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      selected: selected,
      selectedShadowColor: selectedShadowcolor,
      shadowColor: selectedShadowcolor,
      selectedColor: Colors.transparent,
      onSelected: onSelected,
    );
  }
}
