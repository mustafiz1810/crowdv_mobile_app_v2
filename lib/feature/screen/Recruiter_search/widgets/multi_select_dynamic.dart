import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<dynamic> items;
  final dynamic selectedItem;
  const MultiSelect({Key key, this.items,this.selectedItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
   List<int> _selectedItems = [];
   List<String> _selectedName = [];
   @override
   void initState() {
     _selectedItems=widget.selectedItem;
     super.initState();
   }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(int itemValue,String itemName, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
        _selectedName.add(itemName);
      } else {
        _selectedItems.remove(itemValue);
        _selectedName.remove(itemName);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item['id']),
            title: Text(item['name']),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item['id'],item['name'],isChecked),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}