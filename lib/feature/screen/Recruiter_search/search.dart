import 'dart:convert';
import 'package:empty_widget/empty_widget.dart';
import 'package:http/http.dart' as http;
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/category_model.dart';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/search_pages/category.dart';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/search_pages/location.dart';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/search_pages/search_v.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/search_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String token = "";
  @override
  void initState() {
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

  List<String> countries = [
    'Alabama',
    'Alaska',
    'California',
    'Connecticut',
    'Delaware',
    'Florida',
    'Illinois',
    'Kansas',
    'Kentucky',
    'Louisiana'
  ];
  List<String> AlabamaProvince = ['Birmingham', 'Montgomery'];
  List<String> AlaskaProvince = [
    'Anchorage',
    'Juneau',
  ];
  List<String> CaliforniaProvince = ['Los Angeles', 'Sacramento'];
  List<String> ConnecticutProvince = ['Bridgeport', 'Hartford'];
  List<String> DelawareProvince = ['Dover', 'Wilmington'];
  List<String> FloridaProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> IllinoisProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> KansasProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> KentuckyProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> LouisianaProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> provinces = [];
  String selectedCountry;
  String selectedProvince;
  TextEditingController volunteerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: DefaultTabController(
        length: 3,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: TabBar(
                tabs: [
                  Tab(
                      icon: Icon(Icons.category),
                      child: const Text('Category')),
                  Tab(
                      icon: Icon(Icons.location_on_rounded),
                      child: const Text('Location')),
                  Tab(
                      icon: Icon(Icons.person),
                      child: const Text('Volunteer')),
                ],
                unselectedLabelColor: Colors.black38,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 70.0,
                  indicatorColor: primaryColor,
                  indicatorRadius: 5,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  insets: EdgeInsets.all(2),
                ),
              ),
            ),
            SliverFillRemaining(
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        FutureBuilder<CategoryModel>(
                          future: getCategoryApi(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.data.data.length == 0) {
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
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GridView.builder(
                                      gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 150,
                                          childAspectRatio: 2 / 2,
                                          crossAxisSpacing: 15,
                                          mainAxisSpacing: 15),
                                      itemCount: snapshot.data.data.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return SearchCard(
                                          title: snapshot.data.data[index].name,
                                          svgSrc: snapshot.data.data[index].image,
                                          press: () {
                                            Get.to(() => Category(
                                              token: token,
                                              categoryId: snapshot
                                                  .data.data[index].id,
                                            ));
                                          },
                                        );
                                      }),
                                );
                              }
                            } else if (snapshot.connectionState == ConnectionState.none) {
                              return Text('Error'); // error
                            } else {
                              return Center(child: CircularProgressIndicator()); // loading
                            }
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(18),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: "State",
                                        hintText: "State",
                                        fillColor: Colors.white,
                                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                        filled: true,
                                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(color: Colors.black)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(color: Colors.black)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide:
                                            BorderSide(color: Colors.red, width: 2.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide:
                                            BorderSide(color: Colors.red, width: 2.0)),
                                      ),
                                      isEmpty: selectedCountry == '',
                                      child:  Center(
                                        child: DropdownButton<String>(
                                          hint: Center(
                                            child: Text(
                                              "Select State",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ),
                                          underline: SizedBox(),
                                          iconEnabledColor:
                                          Colors.black,
                                          value: selectedCountry,
                                          isExpanded: true,
                                          items: countries
                                              .map((String value) {
                                            return DropdownMenuItem<
                                                String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          selectedItemBuilder:
                                              (BuildContext
                                          context) =>
                                              countries
                                                  .map(
                                                      (e) =>
                                                      Center(
                                                        child:
                                                        Text(
                                                          e,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ))
                                                  .toList(),
                                          onChanged: (country) {
                                            if (country ==
                                                'Alabama') {
                                              provinces =
                                                  AlabamaProvince;
                                            } else if (country ==
                                                'Alaska') {
                                              provinces =
                                                  AlaskaProvince;
                                            } else if (country ==
                                                'California') {
                                              provinces =
                                                  CaliforniaProvince;
                                            } else if (country ==
                                                'Connecticut') {
                                              provinces =
                                                  ConnecticutProvince;
                                            } else if (country ==
                                                'Delaware') {
                                              provinces =
                                                  DelawareProvince;
                                            } else if (country ==
                                                'Florida') {
                                              provinces =
                                                  FloridaProvince;
                                            } else if (country ==
                                                'Illinois') {
                                              provinces =
                                                  IllinoisProvince;
                                            } else if (country ==
                                                'Kansas') {
                                              provinces =
                                                  KansasProvince;
                                            } else if (country ==
                                                'Kentucky') {
                                              provinces =
                                                  KentuckyProvince;
                                            } else if (country ==
                                                'Louisiana') {
                                              provinces =
                                                  LouisianaProvince;
                                            } else {
                                              provinces = [];
                                            }
                                            setState(() {
                                              selectedProvince = null;
                                              selectedCountry =
                                                  country;
                                              print(selectedCountry
                                                  .toString());
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: "City",
                                        hintText: "City",
                                        fillColor: Colors.white,
                                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                        filled: true,
                                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(color: Colors.black)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(color: Colors.black)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide:
                                            BorderSide(color: Colors.red, width: 2.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide:
                                            BorderSide(color: Colors.red, width: 2.0)),
                                      ),
                                      isEmpty: selectedProvince == '',
                                      child:  Center(
                                        child: DropdownButton<String>(
                                          hint: Center(
                                            child: Text(
                                              'Select City',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          underline: SizedBox(),
                                          iconEnabledColor:
                                          Colors.black,
                                          value: selectedProvince,
                                          isExpanded: true,
                                          items: provinces
                                              .map((String value) {
                                            return DropdownMenuItem<
                                                String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          selectedItemBuilder:
                                              (BuildContext
                                          context) =>
                                              provinces
                                                  .map(
                                                      (e) =>
                                                      Center(
                                                        child:
                                                        Text(
                                                          e,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ))
                                                  .toList(),
                                          onChanged: (province) {
                                            setState(() {
                                              selectedProvince =
                                                  province;
                                              print(selectedProvince
                                                  .toString());
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                        'Zip Code',
                                        'Enter your zip code'),
                                  ),
                                  decoration: ThemeHelper()
                                      .inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 50),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox.fromSize(
                                      size:
                                          Size(70, 70), // button width and height
                                      child: ClipOval(
                                        child: Material(
                                          color: primaryColor, // button color
                                          child: InkWell(
                                            splashColor:
                                                secondaryColor, // splash color
                                            onTap: () {
                                              Get.to(Location(token: token,location: selectedCountry,));
                                            }, // button pressed
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                ), // icon
                                                Text(
                                                  "Search",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ), // text
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: volunteerController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Search volunteer'),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox.fromSize(
                                    size:
                                        Size(70, 70), // button width and height
                                    child: ClipOval(
                                      child: Material(
                                        color: primaryColor, // button color
                                        child: InkWell(
                                          splashColor:
                                              secondaryColor, // splash color
                                          onTap: () {
                                            Get.to(() => Search(token: token,search: volunteerController.text.toString(),));
                                          }, // button pressed
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.search,
                                                color: Colors.white,
                                              ), // icon
                                              Text(
                                                "Search",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ), // text
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
