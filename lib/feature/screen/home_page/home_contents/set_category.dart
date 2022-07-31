import 'dart:convert';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/models/recruiter/category_model.dart';

class SetCategory extends StatefulWidget {
  const SetCategory({Key key}) : super(key: key);

  @override
  _SetCategoryState createState() => _SetCategoryState();
}

class _SetCategoryState extends State<SetCategory> {
  String token = "";

  @override
  void initState() {
    tempArray.add("Melyna Gislason");
    tempArray.add("Aracely Jaskolski Jr.");
    print(tempArray);
    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future<CategoryModel> getCategoryApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'categories'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(data);
    } else {
      return CategoryModel.fromJson(data);
    }
  }
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
                child: FutureBuilder<CategoryModel>(
                  future: getCategoryApi(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.data.length,
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
                                leading:  CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.network(snapshot.data.data[index].image),
                                ),
                                title: Text(snapshot.data.data[index].name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
                                trailing:  InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(tempArray.contains(snapshot.data.data[index].name)){
                                        getRequestWithoutParam(
                                            '/api/v1/remove-category/${snapshot.data.data[index].id}',
                                            {
                                              'Content-Type':
                                              "application/json",
                                              "Authorization":
                                              "Bearer $token"
                                            }).then((value) async { showToast(context,
                                            'remove');
                                        });
                                        tempArray.remove(snapshot.data.data[index].name);
                                      }else{
                                        getRequestWithoutParam(
                                            '/api/v1/set-category/${snapshot.data.data[index].id}',
                                            {
                                              'Content-Type':
                                              "application/json",
                                              "Authorization":
                                              "Bearer $token"
                                            }).then((value) async {
                                          showToast(context,
                                              'Added');
                                        });
                                        tempArray.add(snapshot.data.data[index].name);
                                      }
                                    });
                                    print(tempArray.toString());
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 35,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    decoration: BoxDecoration(
                                      color: tempArray.contains(snapshot.data.data[index].name)?Colors.red:primaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(tempArray.contains(snapshot.data.data[index].name)?'Remove':'Add',
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
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_1,
                          title: 'Empty',
                          titleTextStyle: TextStyle(
                            fontSize: 22,
                            color: Color(0xff9da9c7),
                            fontWeight: FontWeight.w500,
                          ),
                          subtitleTextStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xffabb8d6),
                          ),
                        ),
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
