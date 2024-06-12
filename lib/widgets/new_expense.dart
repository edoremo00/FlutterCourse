import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';


class NewExpense extends StatefulWidget {
  final void Function(Expense newxp) onAddExpense;
  final void Function(Expense modexp) onModifyExpense;
  Expense? existingExpense;
  String? currencySymbol;
  NewExpense({super.key,required this.onAddExpense,required this.onModifyExpense,required this.currencySymbol,this.existingExpense});
  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // final _titleController = TextEditingController();
  // final _amountController = TextEditingController();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _datecontroller;
  final FocusNode _dateFocusNode = FocusNode(); 

  DateTime? _pickedDate;
  

  Category? _selectedCategory;

 @override
  void initState() {
    super.initState();
    _titleController=TextEditingController(text: widget.existingExpense?.title ?? "");
    _amountController=TextEditingController(text:widget.existingExpense?.amount.toString() ?? "");
    _datecontroller=TextEditingController(text:widget.existingExpense?.formattedDate ?? "");
    widget.existingExpense?.date !=null ? _pickedDate=widget.existingExpense?.date : _pickedDate;
    widget.existingExpense?.category !=null ? _selectedCategory=widget.existingExpense?.category : _selectedCategory;
  }


  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _openDatepicker() async{
    final now=DateTime.now();
    final firstdate=DateTime(now.year-1,DateTime.january);
    final pickedDate=await showDatePicker(
      context: context,
      initialDate: _datecontroller.text.isEmpty ? DateTime.now() : formatter.parse(_datecontroller.text),
      firstDate: firstdate,
      lastDate: now,
    );
    if(pickedDate!=null){
      setState(() {
        _datecontroller.text=formatter.format(pickedDate);
      });
    }
    if(!context.mounted) return;
    // Remove focus when cancel is pressed from datepicker
    _dateFocusNode.unfocus();      
    
    // setState(() {
    //   _pickedDate=pickedDate;
    // });
  }

  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final isAmountinvalid = enteredAmount == null || enteredAmount <= 0;
    final isCategoryinvalid = _selectedCategory == null;
    final enteredDate =formatter.tryParse(_datecontroller.text);
    final isDateinvalid=enteredDate==null;
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
    if(widget.existingExpense!=null){
        //do the editing
        widget.existingExpense!.title=_titleController.text;
        widget.existingExpense!.amount=enteredAmount;
        widget.existingExpense!.category=_selectedCategory!;
        widget.existingExpense!.date=enteredDate;
        widget.onModifyExpense(widget.existingExpense!);
        
    }else{
      Expense newexp = Expense(

          title: _titleController.text,
          amount: enteredAmount,
          expdate: enteredDate,
          category: _selectedCategory!);

      //call add function passed from expenses list page
      widget.onAddExpense(newexp);

    }
    
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
          left: 16,
          right: 16,
          top:20
         ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            //TODO test multiple chips inside a row with mainaxisalignemt to see if spacing works
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 8),
                  label: Text("Title"),
                ),
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        label: const Text("Amount"),
                        prefixText: widget.currencySymbol,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32,),
                  Expanded(
                      child: TextField(
                        focusNode: _dateFocusNode,
                        controller: _datecontroller,
                        readOnly: true,
                        onTap: _openDatepicker,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          label: const Text("Date"),
                          prefixIcon: Ink(
                            child: const Icon(Icons.calendar_month),
                          ),
                        ),
                      ),
                    )
              
                  //OLD DATE PICKER IMPLEMENTATION AND STYLING
                  // Expanded(
                  //   child: InkWell(
                  //     onTap: _openDatepicker,
                  //     child: Container(
                  //       alignment: Alignment.topRight,
                  //       decoration: const BoxDecoration(
                  //         border: Border(
                  //           bottom: BorderSide(color:Colors.grey, width: 1.5),
                  //         ),
                  //       ),
                  //       child: SizedBox(
                  //         height: 40,
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             //padding per muovere un filo più in giù testo ed allinearlo ad altro in altra textfield
                  //               Text(
                  //                 _pickedDate!=null ? formatter.format(_pickedDate!) : "Selected Date",
                  //                 style: const TextStyle(fontSize: 16,color: Color.fromARGB(255, 56, 56, 56),),
                  //               ),
                  //             IconButton(
                  //               onPressed: _openDatepicker,
                  //               icon: const Icon(Icons.calendar_month),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  
                ],
              ),
              const SizedBox(height: 32),
              SingleChildScrollView(scrollDirection: Axis.horizontal,clipBehavior: Clip.hardEdge,child: Wrap(
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
              const SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _submitExpenseData,
                      child: const Text("Save",style: TextStyle(fontSize: 16),),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
          Positioned(
            top: -20,
            right: -16,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
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
