import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  double previousPadding = 0.0;

  // late String currencySymbol;
  String currencySymbol="";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     retrieveCurrencySymbol();
  }
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void retrieveCurrencySymbol(){
    final locale=View.of(context).platformDispatcher.locale.toLanguageTag();
    final formatted=NumberFormat.simpleCurrency(locale: locale);
    if(formatted.currencySymbol !=currencySymbol){
      setState(() {
         currencySymbol=formatted.currencySymbol;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    //esempio closure inutile
    // setBottompadding();
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text("Title"),
            ),
          ),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: InputDecoration(
              label: const Text("Amount"),
              prefixText: currencySymbol,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("Save"),
              ),
            ],
          )
        ],
      ),
    );
  }

  // void setBottompadding(){
  //   var currentBottompadding=MediaQuery.of(context).viewInsets.bottom;
  //   Function shouldBottompaddingChange=(double padding){
  //     double result=(currentBottompadding>padding && currentBottompadding !=0.0) ? currentBottompadding : padding;
  //     previousPadding=result;
  //     if(result==padding) return currentBottompadding;
  //     return result;
  //   };
  //   previousPadding=shouldBottompaddingChange(previousPadding);
      
  // }

}

