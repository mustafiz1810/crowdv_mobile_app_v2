import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/Search/search_pages/category.dart';
import 'package:crowdv_mobile_app/feature/screen/Search/search_pages/location.dart';
import 'package:crowdv_mobile_app/feature/screen/Search/search_pages/search_v.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/search_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  List<String> countries = ['Alabama', 'Alaska','California','Connecticut','Delaware','Florida','Illinois','Kansas','Kentucky','Louisiana'];
  List<String> AlabamaProvince = ['Birmingham', 'Montgomery'];
  List<String> AlaskaProvince = ['Anchorage', 'Juneau',];
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
              child:  TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.category), child: const Text('Category')),
                  Tab(
                      icon: Icon(Icons.location_on_rounded),
                      child: const Text('Location')),
                  Tab(
                      icon: Icon(Icons.person),
                      child: const Text('Recruiter\nVolunteer')),
                ],
                unselectedLabelColor: Colors.black38,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 70.0,
                  indicatorColor: primaryColor,
                  indicatorRadius: 5,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
// Other flags
// indicatorRadius: 1,
                  insets: EdgeInsets.all(2),
// padding: EdgeInsets.all(10)
                ),
              ),
            ),
            SliverFillRemaining(
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: GridView.count(
// scrollDirection: Axis.horizontal,
                            crossAxisCount: 3,
                            childAspectRatio: .90,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 2,
                            children: <Widget>[
                              SearchCard(
                                title: "Academic",
                                svgSrc: "assets/94.svg",
                                press: () {},
                              ),
                              SearchCard(
                                title: "Communication",
                                svgSrc: "assets/390.svg",
                                press: () {
                                  Get.to(() => Category());
                                },
                              ),
                              SearchCard(
                                title: "Entertainment",
                                svgSrc: "assets/347.svg",
                                press: () {
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) {
//     return DetailsScreen();
//   }),
// );
                                },
                              ),
                              SearchCard(
                                title: "Housekeeping",
                                svgSrc: "assets/undraw_clean_up_re_504g.svg",
                                press: () {},
                              ),
                              SearchCard(
                                title: "Language",
                                svgSrc: "assets/309.svg",
                                press: () {},
                              ),
                              SearchCard(
                                title: "Medication",
                                svgSrc: "assets/377.svg",
                                press: () {},
                              ),
                              SearchCard(
                                title: "Others",
                                svgSrc: "assets/7.svg",
                                press: () {},
                              ),
                              SearchCard(
                                title: "Professional\nSkills",
                                svgSrc: "assets/432.svg",
                                press: () {},
                              ),
                              SearchCard(
                                title: "Shopping",
                                svgSrc: "assets/58.svg",
                                press: () {},
                              ),
                              SearchCard(
                                title: "Transportation",
                                svgSrc: "assets/83.svg",
                                press: () {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 350,
                                child: Center(
                                  child: DropdownButton<String>(
                                    hint: Center(
                                      child: Text(
                                        'Select State',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    underline: SizedBox(),
                                    iconEnabledColor: Colors.white,
                                    value: selectedCountry,
                                    isExpanded: true,
                                    items: countries.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (BuildContext context) =>
                                        countries
                                            .map((e) => Center(
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                            .toList(),
                                    onChanged: (country) {
                                      if (country == 'Alabama') {
                                        provinces = AlabamaProvince;
                                      } else if (country == 'Alaska') {
                                        provinces = AlaskaProvince;
                                      } else if (country == 'California') {
                                        provinces = CaliforniaProvince;
                                      }else if (country == 'Connecticut') {
                                        provinces = ConnecticutProvince;
                                      }else if (country == 'Delaware') {
                                        provinces = DelawareProvince;
                                      }else if (country == 'Florida') {
                                        provinces = FloridaProvince;
                                      }else if (country == 'Illinois') {
                                        provinces = IllinoisProvince;
                                      }else if (country == 'Kansas') {
                                        provinces = KansasProvince;
                                      }else if (country == 'Kentucky') {
                                        provinces = KentuckyProvince;
                                      }else if (country == 'Louisiana') {
                                        provinces = LouisianaProvince;
                                      }
                                      else {
                                        provinces = [];
                                      }
                                      setState(() {
                                        selectedProvince = null;
                                        selectedCountry = country;
                                        print(selectedCountry.toString());
                                      });
                                    },
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 2.0)
                                  ],
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 360,
                                child: Center(
                                  child:DropdownButton<String>(
                                    hint: Center(
                                      child: Text(
                                        'Select City',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    underline: SizedBox(),
                                    value: selectedProvince,
                                    isExpanded: true,
                                    items: provinces.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (BuildContext context) =>
                                        provinces
                                            .map((e) => Center(
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                            .toList(),
                                    onChanged: (province) {
                                      setState(() {
                                        selectedProvince = province;
                                        print(selectedProvince.toString());
                                      });
                                    },
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 2.0)
                                  ],
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: TextFormField(
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Zip Code', 'Enter your zip code'),
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox.fromSize(
                                    size: Size(70, 70), // button width and height
                                    child: ClipOval(
                                      child: Material(
                                        color: primaryColor, // button color
                                        child: InkWell(
                                          splashColor: secondaryColor, // splash color
                                          onTap: () {
                                            Get.to(Location());
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
                                                style: TextStyle(color: Colors.white),
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
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: TextFormField(
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Search volunteer/recruiter',
                                      'Enter your zip code'),
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox.fromSize(
                                    size: Size(70, 70), // button width and height
                                    child: ClipOval(
                                      child: Material(
                                        color: primaryColor, // button color
                                        child: InkWell(
                                          splashColor: secondaryColor, // splash color
                                          onTap: () {
                                            Get.to(() => Search());
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
                                                style: TextStyle(color: Colors.white),
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
