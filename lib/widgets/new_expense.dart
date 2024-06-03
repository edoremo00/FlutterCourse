import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/expense.dart';
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

  DateTime? _pickedDate;
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

  void retrieveCurrencySymbol() {
    final locale = View.of(context).platformDispatcher.locale.toLanguageTag();
    final formatted = NumberFormat.simpleCurrency(locale: locale);
    if (formatted.currencySymbol != currencySymbol) {
      setState(() {
        currencySymbol = formatted.currencySymbol;
      });
    }
  }

  void _openDatepicker() async{
    final now=DateTime.now();
    final firstdate=DateTime(now.year-1,now.month,now.day);
    final pickedDate=await showDatePicker(
      context: context,
      firstDate: firstdate,
      lastDate: now
    );
    _pickedDate=pickedDate;
    setState(() {
      
    });
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
        // crossAxisAlignment: CrossAxisAlignment.end,
        //TODO fix X button alignment
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    label: const Text("Amount"),
                    prefixText: currencySymbol,
                  ),
                ),
              ),
              const SizedBox(width: 32,),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color:Colors.grey, width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //padding per muovere un filo più in giù testo ed allinearlo ad altro in altra textfield
                        Padding(
                        padding:const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _pickedDate!=null ? dateOnlyFormatter.format(_pickedDate!) : "Selected Date",
                          style: const TextStyle(fontSize: 16,color: Color.fromARGB(255, 56, 56, 56),),
                        ),
                      ),
                      IconButton(
                        onPressed: _openDatepicker,
                        icon: const Icon(Icons.calendar_month),
                      )
                    ],
                  ),
                ),
              ),
              
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(scrollDirection: Axis.horizontal,child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //TODO fix spacing between Chip
            children: [
              ...categoryIcons.entries.map(
                (entry) => Chip(
                  avatar: Icon(entry.value),
                  label: Text(entry.key.name),
                ),
              )
            ],
          ),),
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
