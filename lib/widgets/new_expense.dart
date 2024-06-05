import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense newxp) onAddExpense;
  const NewExpense({super.key,required this.onAddExpense});
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
  

  Category? _selectedCategory;


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
    final firstdate=DateTime(now.year-1,DateTime.january);
    final pickedDate=await showDatePicker(
      context: context,
      firstDate: firstdate,
      lastDate: now
    );
    setState(() {
      _pickedDate=pickedDate;
    });
  }

  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final isAmountinvalid = enteredAmount == null || enteredAmount <= 0;
    final isCategoryinvalid = _selectedCategory == null;
    final isDateinvalid = _pickedDate == null;
    if (_titleController.text.trim().isEmpty ||
        isAmountinvalid ||
        isCategoryinvalid ||
        isDateinvalid) {
      //error
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150,
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 229, 174, 9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: const Center(
                  child: Icon(Icons.sentiment_dissatisfied,size: 85,),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Oh no!",
                style: TextStyle(fontSize: 24),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Please make sure a value is provided for all the fields",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
          // content: const Text("Please make sure the fields have a value"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Got it!"),)
          ],
        ),
      );
      return;
    }

    Expense newexp = Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _pickedDate!,
        category: _selectedCategory!);

  //call add function passed from expenses list page
    widget.onAddExpense(newexp);

    //close modal bottom sheet
    Navigator.pop(context);
   
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
        //TODO test multiple chips inside a row with mainaxisalignemt to see if spacing works
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
                          _pickedDate!=null ? formatter.format(_pickedDate!) : "Selected Date",
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
          const SizedBox(height: 32),
          SingleChildScrollView(scrollDirection: Axis.horizontal,clipBehavior: Clip.none,child: Wrap(
            spacing: 16,
            children: [
              ...categoryIcons.entries.map(
                (entry) {
                  return ChoiceChip(
                  showCheckmark: false,
                  selected: _selectedCategory==entry.key,
                  onSelected: (_){
                    setState(() {
                      _selectedCategory=entry.key;
                    });
                  },
                  padding: const EdgeInsets.all(6),
                  labelPadding: const EdgeInsets.all(6),
                  avatar: CircleAvatar(child: Icon(entry.value),),
                  label: Text(entry.key.name.toUpperCase(),),
                );} 
                
              ),
            ],
          ),),
          Row(
            children: [
              ElevatedButton(
                onPressed: _submitExpenseData,
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
