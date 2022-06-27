import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:flutter/material.dart';

class SetCategory extends StatefulWidget {
  const SetCategory({Key key}) : super(key: key);

  @override
  _SetCategoryState createState() => _SetCategoryState();
}

class _SetCategoryState extends State<SetCategory> {
  List<String> name = ['Academic','Communication','Entertainment'];
  List<IconData> icon = [Icons.book,Icons.chat,Icons.slideshow_outlined];
  List<String> tempArray=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Category'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: name.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Container(
                        margin: const EdgeInsets.only(top:15,),
                    padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.white,
                        Colors.white,
                      ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: Offset(1, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                      child: ListTile(
                        leading:  IconBox(
                          child: Icon(
                            icon[index],
                            color: Colors.white,
                            size: 25,
                          ),
                          bgColor: primaryColor,
                        ),
                        title: Text(name[index].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: primaryColor)),
                        trailing:  InkWell(
                          onTap: (){
                            setState(() {
                              if(tempArray.contains(name[index].toString())){
                                tempArray.remove(name[index].toString());
                              }else{
                                tempArray.add(name[index].toString());
                              }
                            });
                            print(tempArray.toString());
                          },
                          child: Container(
                            width: 80,
                            height: 35,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            decoration: BoxDecoration(
                              color: tempArray.contains(name[index].toString())?Colors.red:primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                                child: Text(tempArray.contains(name[index].toString())?'Remove':'Add',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white))),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
