import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/widgets/expenses-list/expense_type_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense newxp) onAddExpense;
  final void Function(Expense modexp) onModifyExpense;
  void Function()? onHandleSearchRefresh;
  Expense? existingExpense;
  String? currencySymbol;
  NewExpense(
      {super.key,
      required this.onAddExpense,
      required this.onModifyExpense,
      required this.currencySymbol,
      this.existingExpense,
      this.onHandleSearchRefresh});
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

  ExpenseType? _selectedExpensetype;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingExpense?.title ?? "");
    _amountController = TextEditingController(
        text: widget.existingExpense?.amount.toString() ?? "");
    _datecontroller = TextEditingController(
        text: widget.existingExpense?.formattedDate ?? "");
    widget.existingExpense?.date != null
        ? _pickedDate = widget.existingExpense?.date
        : _pickedDate;
    widget.existingExpense?.category != null
        ? _selectedCategory = widget.existingExpense?.category
        : _selectedCategory;
    widget.existingExpense?.expenseType != null
        ? _selectedExpensetype = widget.existingExpense?.expenseType
        : _selectedExpensetype;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _openDatepicker() async {
    final now = DateTime.now();
    final firstdate = DateTime(now.year - 1, DateTime.january);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _datecontroller.text.isEmpty
          ? DateTime.now()
          : formatter.parse(_datecontroller.text),
      firstDate: firstdate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _datecontroller.text = formatter.format(pickedDate);
      });
    }
    if (!context.mounted) return;
    // Remove focus when cancel is pressed from datepicker
    _dateFocusNode.unfocus();

    // setState(() {
    //   _pickedDate=pickedDate;
    // });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final isAmountinvalid = enteredAmount == null || enteredAmount <= 0;
    final isCategoryinvalid = _selectedCategory == null;
    final enteredDate = formatter.tryParse(_datecontroller.text);
    final isDateinvalid = enteredDate == null;
    final isExpensetypeInvalid=_selectedExpensetype==null;
    if (_titleController.text.trim().isEmpty ||
        isAmountinvalid ||
        isCategoryinvalid ||
        isDateinvalid ||isExpensetypeInvalid) {
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
                  child: Icon(
                    Icons.sentiment_dissatisfied,
                    size: 85,
                  ),
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
              child: const Text("Got it!"),
            )
          ],
        ),
      );
      return;
    }
    if (widget.existingExpense != null) {
      //do the editing
      widget.existingExpense!.title = _titleController.text;
      widget.existingExpense!.amount = enteredAmount;
      widget.existingExpense!.category = _selectedCategory!;
      widget.existingExpense!.date = enteredDate;
      widget.existingExpense!.expenseType=_selectedExpensetype!;
      widget.onModifyExpense(widget.existingExpense!);

      if (widget.onHandleSearchRefresh != null) {
        //we are in the searchpage and the user has edited the information. refresh the search to show update data
        widget.onHandleSearchRefresh!();
      }
    } else {
      Expense newexp = Expense(
          expenseType: _selectedExpensetype!,
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
          top: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //TODO test multiple chips inside a row with mainaxisalignemt to see if spacing works
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 35, bottom: 12),
                  // padding: EdgeInsets.zero,
                  child:  Wrap(
                      alignment: WrapAlignment.center,
                      // runAlignment: WrapAlignment.spaceEvenly,
                      direction: Axis.horizontal,
                      spacing: 16,
                      runSpacing: 9,
                      children: [
                        ...expenseTypes.entries.map(
                          // (e) => ChoiceChip(
                          //   showCheckmark: false,      
                          //   label: Text(e.key.name,style: TextStyle(color: _selectedExpensetype==e.key ? e.value : Theme.of(context).textTheme.bodySmall?.color),),
                          //   padding: const EdgeInsets.all(12),
                          //   shape: RoundedRectangleBorder(
                          //     side: BorderSide(
                          //       color: _selectedExpensetype==e.key ? e.value : Colors.transparent, // Border color
                          //       width: 2.0, // Border width
                          //     ),
                          //     borderRadius:
                          //         BorderRadius.circular(8.0), // Border radius
                          //   ),
                          //   selected: _selectedExpensetype==e.key,
                          //   selectedShadowColor: e.value,
                          //   shadowColor: e.value,
                          //   selectedColor: Colors.transparent,
                            
                            
                          //   onSelected: (_) {
                          //     setState(() {
                          //       _selectedExpensetype=e.key;
                          //     });
                          //   },
                          // ),
                          (e)=>ExpenseTypeFilter(
                            label:  Text(e.key.name,style: TextStyle(color: _selectedExpensetype==e.key ? e.value : Theme.of(context).textTheme.bodySmall?.color),),
                            borderColor: _selectedExpensetype==e.key ? e.value : Colors.transparent,
                            selected: _selectedExpensetype==e.key,
                            onSelected: (_) {
                              setState(() {
                                _selectedExpensetype=e.key;
                              });
                            },
                          )
                        )
                      ]),
                ),
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 8),
                    label: Text("Title"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                    const SizedBox(
                      width: 32,
                    ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.hardEdge,
                  child: Wrap(
                    spacing: 12,
                    children: [
                      ...categoryIcons.entries.map((entry) {
                        return ChoiceChip(
                          showCheckmark: false,
                          selected: _selectedCategory == entry.key,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = entry.key;
                            });
                          },
                          padding: const EdgeInsets.all(4),
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 9),
                          // padding: const EdgeInsets.all(6),
                          // labelPadding: const EdgeInsets.all(6),
                          avatar: entry.value != null
                              ? CircleAvatar(
                                  child: Icon(entry.value),
                                )
                              : null,
                          label: Text(
                            entry.key.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _submitExpenseData,
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 16),
                        ),
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
}
