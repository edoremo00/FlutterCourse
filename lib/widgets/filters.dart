import 'package:expensetracker/expenses.dart';
import 'package:expensetracker/models/category.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/models/filter.dart';
import 'package:expensetracker/models/sorting.dart';
import 'package:flutter/material.dart';

class FiltersWidget extends StatefulWidget {
  final List<Expense> Function ({Filter? filterObj}) onFilterandSort;
  Filter? lastAppliedfilterObj;
  FiltersWidget({super.key,required this.onFilterandSort,this.lastAppliedfilterObj});

  @override
  State<StatefulWidget> createState() {
    return FiltersWidgetstate();
  }
}

class FiltersWidgetstate extends State<FiltersWidget> {
  String defaultSortdir = SortDirection.up.name;
  List<Category> _selectedCategories=[];
  Sorting? _selectedSorting;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              const Spacer(),
              Text("Filters and sort",
                  style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onFilterandSort(
                  filterObj:  Filter(
                      categories: _selectedCategories.isEmpty ? (widget.lastAppliedfilterObj?.categories) : _selectedCategories,
                      sorting: _selectedSorting ?? widget.lastAppliedfilterObj?.sorting,
                      sortDirection: _selectedSorting != null
                          ? SortDirection.values.byName(defaultSortdir)
                          : widget.lastAppliedfilterObj?.sortDirection,
                    ),
                  );
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 6, left: 20),
          child:
              Text("Categories", style: Theme.of(context).textTheme.titleSmall),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          //nel caso in cui io abbia più categorie limita altezza bottomsheet e metti scroll
          constraints: const BoxConstraints(maxHeight: 250),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              spacing: 16,
              runSpacing: 9,
              children: [
                ...categoryIcons.entries.map((entry) {
                  // return ChoiceChip(
                  //   showCheckmark: false,
                  //   selected: _selectedCategory == entry.key,
                  //   onSelected: (_) {
                  //     setState(() {
                  //       _selectedCategory = entry.key;
                  //     });
                  //   },
                  //   padding: const EdgeInsets.all(4),
                  //   labelPadding:
                  //       const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  //   avatar: CircleAvatar(
                  //     child: Icon(entry.value),
                  //   ),
                  //   label: Text(
                  //     style: Theme.of(context).textTheme.bodySmall,
                  //     entry.key.name,
                  //   ),
                  // );
                  return FilterChip(
                    label: Text(
                      style: Theme.of(context).textTheme.bodySmall,
                      entry.key.name,
                    ),
                    onSelected: (_) {
                      if(!_selectedCategories.contains(entry.key)){
                        setState(() {
                          _selectedCategories.add(entry.key);
                        });
                      }
                      if(widget.lastAppliedfilterObj?.categories!=null){
                        final categories=widget.lastAppliedfilterObj!.categories!;
                        if(categories.isNotEmpty){
                          List<Category> temp=[];
                          for(var category in categories){
                            if(_selectedCategories.contains(category)){
                              continue;
                            }else{
                              temp.add(category);
                            }
                          }
                          setState(() {
                            _selectedCategories.addAll(temp);
                          });
                        }
                      }
                      
                    },
                    selected: _selectedCategories.contains(entry.key) || (widget.lastAppliedfilterObj?.categories?.contains(entry.key) ?? false),
                    onDeleted: () {
                      setState(() {
                        _selectedCategories.remove(entry.key);
                        widget.lastAppliedfilterObj?.categories?.remove(entry.key);
                      });
                    },
                    showCheckmark: false,
                    avatar:entry.value!=null ?  CircleAvatar(child: Icon(entry.value),) : null,
                    padding: const EdgeInsets.all(4),
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  );
                }),
              ],
            ),
          ),
        ),
        const Divider(
          indent: 12,
          endIndent: 12,
        ),
        Container(
          margin: const EdgeInsets.only(top: 3),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Order by", style: Theme.of(context).textTheme.titleSmall),
              Opacity(
                opacity: _selectedSorting != null || widget.lastAppliedfilterObj?.sorting!=null ? 1 : 0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      defaultSortdir = defaultSortdir == SortDirection.up.name
                          ? SortDirection.down.name
                          : SortDirection.up.name;
                    });
                  },
                  //icon:  widget.lastAppliedfilterObj?.sortDirection !=null ?  Icon(widget.lastAppliedfilterObj?.sortDirection ==SortDirection.up ? Icons.arrow_upward : Icons.arrow_downward) : Icon(defaultSortdir ==SortDirection.up.name ? Icons.arrow_upward : Icons.arrow_downward)
                  //TODO FIX DISPLAYED ARROW SHOWING WRONG
                  icon: defaultSortdir == SortDirection.up.name
                      ? const Icon(Icons.arrow_upward)
                      : const Icon(Icons.arrow_downward),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            clipBehavior: Clip.hardEdge,
            child: Wrap(
              spacing: 16,
              runSpacing: 9,
              children: [
                ...sortingIcons.entries.map((entry) {
                  return ChoiceChip(
                    showCheckmark: false,
                    selected: _selectedSorting == entry.key || widget.lastAppliedfilterObj?.sorting==entry.key,
                    onSelected: (_) {
                      //prevent accidental multiple selection if we have a previous sort value
                      if(widget.lastAppliedfilterObj?.sorting!=null){
                        widget.lastAppliedfilterObj?.sorting=null;
                      }
                      setState(() {
                        _selectedSorting = entry.key;
                      });
                    },
                    padding: const EdgeInsets.all(4),
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                    avatar: CircleAvatar(
                      child: Icon(entry.value),
                    ),
                    label: Text(
                      style: Theme.of(context).textTheme.bodySmall,
                      entry.key.name,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
