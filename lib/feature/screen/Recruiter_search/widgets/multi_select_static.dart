import 'package:flutter/material.dart';

class MultiSelectStatic extends StatefulWidget {
  final List<String> items;
  final dynamic selectedItem,title;
  const MultiSelectStatic({Key key, this.items,this.selectedItem,this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectStaticState();
}

class _MultiSelectStaticState extends State<MultiSelectStatic> {
  // this variable holds the selected items
   List<String> _selectedItems = [];
  @override
  void initState() {
    _selectedItems=widget.selectedItem;
    super.initState();
  }
// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue.toString());
        print(itemValue);
      } else {
        _selectedItems.remove(itemValue.toString());
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
      title: Text('Select '+widget.title.toString()),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked),
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
