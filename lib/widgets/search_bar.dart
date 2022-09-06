import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBar extends StatelessWidget {
  final control;

  const SearchBar({Key key, this.control,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
      ),
      child: TextFormField(
        controller: control,
        decoration: InputDecoration(
          suffixIcon: Container(
            margin: EdgeInsets.all(1),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
            ),
            child: IntrinsicHeight(
              child: Icon(Icons.search,color: Colors.white,),
            ),
          ),
          hintText: "Search",
          fillColor: Colors.black12,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.white)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}