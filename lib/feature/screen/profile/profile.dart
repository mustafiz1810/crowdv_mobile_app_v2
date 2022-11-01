import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/profile_model.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/profile_update_basic.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final data,
      role,
      disability,
      chosenValue,
      dropdown,
      country,
      state,
      city,
      zip;
  ProfilePage(
      {this.data,
      this.role,
      this.disability,
      this.chosenValue,
      this.dropdown,
      this.country,
      this.state,
      this.city,
      this.zip});
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  String token = "";

  List<dynamic> array = [];

  void _answerQuestion(String id) {
    if (array.contains(id)) {
      array.remove(id);
    } else {
      array.add(id);
    }
  }

  void initState() {
    countryvalue = widget.country;
    statevalue = widget.state;
    cityvalue = widget.city;
    zipController.text = widget.zip;
    super.initState();
    getCred();
    getCountry();
    widget.state != null ? getState(widget.country) : "";
    widget.city != null ? getCity(widget.state) : "";
    array = widget.disability;
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future<ProfileModel> getProfileApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'profile'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(data);
    } else {
      return ProfileModel.fromJson(data);
    }
  }

  void set(List<dynamic> disable) async {
    String body = json.encode({
      'type_of_disability': disable,
    });
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'profile/update?type=service'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {});
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message'].toString());
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                FlatButton(
                  child: Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  void location(String country, state, city, zip_code) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'profile/update?type=contacts'),
          headers: {
            "Authorization": "Bearer $token"
          },
          body: {
            'country_id': country,
            'state_id': state,
            'city_id': city,
            'zip_code': zip_code,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {});
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['error'].length!=0?data['error'].toString():data['message'].toString());
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                FlatButton(
                  child: Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  TextEditingController zipController = TextEditingController();
  List countries = [];
  Future getCountry() async {
    var baseUrl = NetworkConstants.BASE_URL + 'countries';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        countries = jsonData['data'];
      });
      print(jsonData);
    }
  }

  List states = [];
  Future getState(countryId) async {
    var baseUrl = NetworkConstants.BASE_URL + 'get-state-by-country/$countryId';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        states = jsonData['data'];
      });
    }
  }

  List city = [];
  Future getCity(stateId) async {
    var baseUrl = NetworkConstants.BASE_URL + 'get-city-by-state/$stateId';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        city = jsonData['data'];
      });
    }
  }

  var countryvalue;
  var statevalue;
  var cityvalue;

  upload(
    File imageFile,
  ) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Accept": "application/json"
    };
    // string to uri
    var uri = Uri.parse(NetworkConstants.BASE_URL + 'profile-image');
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    // multipart that takes file
    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: Path.basename(imageFile.path));
    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    //adding params
    // send
    var response = await request.send();
    if (response.statusCode == 200) {
      // print(data);
      showToast(context, 'Updated');
      setState(() {
        _image = null;
      });
    } else {
      showToast(context, 'Failed');
    }
    print(response.statusCode);
    // listen for response
    var result = await response.stream.bytesToString();
    print(result);
  }

  File _image;
  Future UploadImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      upload(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile Page",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder<ProfileModel>(
          future: getProfileApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Stack(children: [
                          SizedBox(
                            height:120,
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: _image == null
                                      ? InkWell(
                                          onTap: () {
                                            UploadImage();
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 12.0,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 15.0,
                                              color: Color(0xFF404040),
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 12.0,
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 20.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                radius: 50.0,
                                backgroundImage: _image == null
                                    ? NetworkImage(snapshot.data.data.image)
                                    : FileImage(_image),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 70,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    snapshot.data.data.membership.icon),
                                radius: 25,
                              ))
                        ]),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data.data.firstName +
                              " " +
                              snapshot.data.data.lastName,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 13,
                            ),
                            Text(
                              snapshot.data.data.state.id != null
                                  ? snapshot.data.data.state.name
                                  : "",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  snapshot.data.data.opportunities.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Opportunity",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data.data.rating.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    )
                                  ],
                                ),
                                Text(
                                  "Rating",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(snapshot.data.data.workingHours.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text("Working Hour",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: TabBar(
                              tabs: [
                                Tab(
                                    icon: Icon(Icons.info_rounded),
                                    child: const Text('Basic Info')),
                                Tab(
                                    icon: Icon(Icons.wheelchair_pickup_rounded),
                                    child: const Text('Disabilities')),
                                Tab(
                                    icon: Icon(Icons.location_on_rounded),
                                    child: const Text('Address')),
                              ],
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black38,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(0xFFfaf9f9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 2,
                                    offset: Offset(
                                        1, 1), // changes position of shadow
                                  ),
                                ],
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
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "User Information",
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ProfileUpdate(
                                                                            token:
                                                                                token,
                                                                            fname:
                                                                                snapshot.data.data.firstName,
                                                                            lname:
                                                                                snapshot.data.data.lastName,
                                                                            about:snapshot.data.data.aboutMe,
                                                                            email:
                                                                                snapshot.data.data.email,
                                                                            phone:
                                                                                snapshot.data.data.phone,
                                                                            dob:
                                                                                snapshot.data.data.dob,
                                                                            prof:
                                                                                snapshot.data.data.profession,
                                                                            institute:snapshot.data.data.institution,
                                                                            gender:
                                                                                snapshot.data.data.gender,
                                                                          )),
                                                            ).then((value) =>
                                                                setState(
                                                                    () {}));
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.black,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                ...ListTile.divideTiles(
                                                  color: Colors.grey,
                                                  tiles: [
                                                    ListTile(
                                                      leading: Icon(Icons
                                                          .person_outline_rounded),
                                                      title: Text("Name:"),
                                                      subtitle: Text(
                                                        snapshot.data.data
                                                                .firstName
                                                                .toString() +
                                                            " " +
                                                            snapshot.data.data
                                                                .lastName,
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                          Icons.email_outlined),
                                                      title: Text("Email:"),
                                                      subtitle: Text(snapshot
                                                          .data.data.email),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(Icons
                                                          .phone_android_rounded),
                                                      title: Text("Phone:"),
                                                      subtitle: Text(snapshot
                                                          .data.data.phone),
                                                    ),
                                                    ListTile(
                                                        leading: Icon(Icons
                                                            .date_range_rounded),
                                                        title: Text(
                                                            "Date of Birth:"),
                                                        subtitle: Text(
                                                            DateFormat.yMMMd()
                                                                .format(snapshot
                                                                    .data
                                                                    .data
                                                                    .dob))),
                                                    ListTile(
                                                        leading: Icon(Icons
                                                            .work_outline_rounded),
                                                        title:
                                                            Text("Profession:"),
                                                        subtitle: Text(snapshot
                                                                    .data
                                                                    .data
                                                                    .profession !=
                                                                null
                                                            ? snapshot.data.data
                                                                .profession
                                                            : "")),
                                                    ListTile(
                                                        leading: Icon(Icons.home_filled),
                                                        title:
                                                        Text("Institution:"),
                                                        subtitle: Text(
                                                            snapshot
                                                                .data
                                                                .data
                                                                .institution != null
                                                                ? snapshot
                                                                .data
                                                                .data
                                                                .institution
                                                                : "Not Provided"
                                                            )),
                                                    ListTile(
                                                        leading:
                                                            Icon(Icons.male),
                                                        title: Text("Gender:"),
                                                        subtitle: Text(snapshot
                                                                    .data
                                                                    .data
                                                                    .gender !=
                                                                null
                                                            ? snapshot.data.data
                                                                .gender
                                                            : "")),
                                                    ListTile(
                                                        leading: Icon(Icons.person_pin_outlined),
                                                        title:
                                                        Text("About me:"),
                                                        subtitle: Text(
                                                            snapshot
                                                                .data
                                                                .data
                                                                .aboutMe != null
                                                                ? snapshot
                                                                .data
                                                                .data
                                                                .aboutMe
                                                                : "Not Provided")),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, top: 10),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: widget.data.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                      child:
                                                          new CheckboxListTile(
                                                              activeColor:
                                                                  primaryColor,
                                                              dense: true,
                                                              //font change
                                                              title: new Text(
                                                                widget.data[
                                                                        index]
                                                                    ["title"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              value: array.contains(widget
                                                                      .data[
                                                                          index]
                                                                          ["id"]
                                                                      .toString())
                                                                  ? true
                                                                  : widget.data[
                                                                          index]
                                                                      [
                                                                      "is_check"],
                                                              onChanged:
                                                                  (bool value) {
                                                                setState(() {
                                                                  widget.data[
                                                                          index]
                                                                      [
                                                                      "is_check"] = value;
                                                                  _answerQuestion(widget
                                                                      .data[
                                                                          index]
                                                                          ["id"]
                                                                      .toString());
                                                                });
                                                              }));
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 300,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13)),
                                                ),
                                                onPressed: () {
                                                  set(array);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "Save",
                                                    style: GoogleFonts.kanit(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(18),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CustomSearchableDropDown(
                                                initialValue: [
                                                  {
                                                    'parameter': 'id',
                                                    'value': widget.country,
                                                  }
                                                ],
                                                items: countries,
                                                label: 'Select Country',
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                        color: Colors.black
                                                    )
                                                ),
                                                dropDownMenuItems:  countries?.map((item) {
                                                  return item['name'];
                                                })?.toList() ??
                                                    [],
                                                onChanged: (newVal) {
                                                  if(newVal!=null)
                                                  {
                                                    setState(() {
                                                      states.clear();
                                                      statevalue = null;
                                                      city.clear();
                                                      cityvalue = null;
                                                      zipController.clear();
                                                      countryvalue = newVal['id'];
                                                      getState(countryvalue);
                                                      print(countryvalue);
                                                    });

                                                  }
                                                  else{
                                                    countryvalue=widget.country;
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CustomSearchableDropDown(
                                                initialValue: [
                                                  {
                                                    'parameter': 'id',
                                                    'value': widget.state,
                                                  }
                                                ],
                                                items: states,
                                                label: 'Division/Province/State',
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                        color: Colors.black
                                                    )
                                                ),
                                                dropDownMenuItems: states.map((item) {
                                                  return item['name'].toString();
                                                }).toList() ??
                                                    [],
                                                onChanged: (newVal)  {
                                                  if(newVal!=null)
                                                  {
                                                    setState(() {
                                                      city.clear();
                                                      cityvalue = null;
                                                      zipController.clear();
                                                      statevalue = newVal['id'];
                                                      print(statevalue);
                                                      getCity(statevalue);
                                                    });
                                                  }
                                                  else{
                                                    statevalue=widget.state;
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CustomSearchableDropDown(
                                                initialValue: [
                                                  {
                                                    'parameter': 'id',
                                                    'value': widget.city,
                                                  }
                                                ],
                                                items: city,
                                                label: 'City',
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                        color: Colors.black
                                                    )
                                                ),
                                                dropDownMenuItems: city.map((item) {
                                                  return item['name'].toString();
                                                }).toList() ??
                                                    [],
                                                onChanged: (newVal) {
                                                  if(newVal!=null)
                                                  {
                                                    cityvalue = newVal['id'];
                                                    zipController.clear();
                                                    print(cityvalue);
                                                  }
                                                  else{
                                                    cityvalue=widget.city;
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  style: TextStyle(fontSize: 14),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: zipController,
                                                  decoration: ThemeHelper()
                                                      .textInputDecoration(
                                                          'Zip Code',
                                                          'Enter your zip code'),
                                                ),
                                                decoration: ThemeHelper()
                                                    .inputBoxDecorationShaddow(),
                                              ),
                                              SizedBox(height: 10),
                                              SizedBox(
                                                height: 50,
                                                width: 300,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13)),
                                                  ),
                                                  onPressed: () {
                                                    location(
                                                        countryvalue.toString(),
                                                        statevalue.toString(),
                                                        cityvalue.toString(),
                                                        zipController.text
                                                            .toString());
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Save",
                                                      style: GoogleFonts.kanit(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
