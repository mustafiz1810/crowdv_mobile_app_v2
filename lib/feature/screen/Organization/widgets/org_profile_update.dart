import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/widgets/progres_hud.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as Path;
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class OrgProfileUpdate extends StatefulWidget {
  final dynamic country_id, state_id, city_id, zip, website, facebook, linkedin;
  OrgProfileUpdate({
    this.country_id,
    this.state_id,
    this.city_id,
    this.zip,
    this.website,
    this.facebook,
    this.linkedin,
  });

  @override
  _OrgProfileUpdateState createState() => _OrgProfileUpdateState();
}

class _OrgProfileUpdateState extends State<OrgProfileUpdate> {
  String token = "";

  @override
  void initState() {
    countryvalue = widget.country_id;
    statevalue = widget.state_id;
    cityvalue = widget.city_id;
    zipController.text = widget.zip;
    websiteController.text = widget.website;
    facebookController.text = widget.facebook;
    linkedinController.text = widget.linkedin;
    super.initState();
    print(countryvalue);
    print(statevalue);
    print(cityvalue);
    getCred();
    getCountry();
    widget.state_id != null ? getState(widget.country_id) : "";
    widget.city_id != null ? getCity(widget.state_id) : "";
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  TextEditingController websiteController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
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
  final _formKey = GlobalKey<FormState>();
  upload(File imageFile, String country, state, city, zip, website, facebook,
      linkedin) async {
    // open a bytestream
    try {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();
      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      };
      // string to uri
      var uri =
          Uri.parse(NetworkConstants.BASE_URL + 'organization/profile/update');
      // create multipart request
      var request = new http.MultipartRequest("POST", uri);
      // multipart that takes file
      var multipartFile = new http.MultipartFile('logo', stream, length,
          filename: Path.basename(imageFile.path));
      // add file to multipart
      request.files.add(multipartFile);
      request.headers.addAll(headers);
      //adding params
      request.fields['state_id'] = state;
      request.fields['country_id'] = country;
      request.fields['city_id'] = city;
      request.fields['zip_code'] = zip;
      request.fields['facebook'] = facebook;
      request.fields['website'] = website;
      request.fields['linkedin'] = linkedin;
      // send
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, 'Updated');
      } else {
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, 'Failed');
      }
      print(response.statusCode);
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } catch (e) {
      setState(() {
        isApiCallProcess = false;
        print(e.toString());
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Please select an image"),
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

  void updateOpp(
      String country, state, city, zip, website, facebook, linkedin) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'organization/profile/update'),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
          body: {
            'state_id': state,
            'country_id': country,
            'city_id': city,
            'zip_code': zip,
            'facebook': facebook,
            'website': website,
            'linkedin': linkedin,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, data['message']);
      } else {
        setState(() {
          isApiCallProcess = false;
        });
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      }
    } catch (e) {
      setState(() {
        isApiCallProcess = false;
        print(e.toString());
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
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

  File _image;
  Future UploadImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: update(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget update(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Update profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: InkWell(
          onTap: () {
            if (_image != null) {
              setState(() {
                isApiCallProcess = true;
              });
              print(countryvalue.toString());
              upload(
                _image,
                countryvalue.toString(),
                statevalue.toString(),
                cityvalue.toString(),
                zipController.text.toString(),
                websiteController.text.toString(),
                facebookController.text.toString(),
                linkedinController.text.toString(),
              );
            } else {
              setState(() {
                isApiCallProcess = true;
              });
              print(countryvalue.toString());
              updateOpp(
                countryvalue.toString(),
                statevalue.toString(),
                cityvalue.toString(),
                zipController.text.toString(),
                websiteController.text.toString(),
                facebookController.text.toString(),
                linkedinController.text.toString(),
              );
            }
          },
          child: Container(
            height: 48,
            width: 60,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(16.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: DesignCourseAppTheme.nearlyBlue.withOpacity(0.5),
                    offset: const Offset(-1.1, -1.1),
                    blurRadius: 1.0),
              ],
            ),
            child: Center(
              child: Text(
                'Update',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.0,
                  color: DesignCourseAppTheme.nearlyWhite,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  child: CircleAvatar(
                    radius: 43.0,
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
                          ? AssetImage("assets/avater.png")
                          : FileImage(_image),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomSearchableDropDown(
                  initialValue: [
                    {
                      'parameter': 'id',
                      'value': widget.country_id,
                    }
                  ],
                  items: countries,
                  label: 'Select Country',
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  dropDownMenuItems: countries?.map((item) {
                        return item['name'];
                      })?.toList() ??
                      [],
                  onChanged: (newVal) {
                    if (newVal != null) {
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
                    } else {
                      // countryvalue=widget.country;
                      countryvalue;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CustomSearchableDropDown(
                  initialValue: [
                    {
                      'parameter': 'id',
                      'value': widget.state_id,
                    }
                  ],
                  items: states,
                  label: 'Division/Province/State',
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  dropDownMenuItems: states.map((item) {
                        return item['name'].toString();
                      }).toList() ??
                      [],
                  onChanged: (newVal) {
                    if (newVal != null) {
                      setState(() {
                        city.clear();
                        cityvalue = null;
                        zipController.clear();
                        statevalue = newVal['id'];
                        print(statevalue);
                        getCity(statevalue);
                      });
                    } else {
                      // statevalue=widget.state;
                      statevalue;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CustomSearchableDropDown(
                  initialValue: [
                    {
                      'parameter': 'id',
                      'value': widget.city_id,
                    }
                  ],
                  items: city,
                  label: 'City',
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  dropDownMenuItems: city.map((item) {
                        return item['name'].toString();
                      }).toList() ??
                      [],
                  onChanged: (newVal) {
                    if (newVal != null) {
                      cityvalue = newVal['id'];
                      zipController.clear();
                      print(cityvalue);
                    } else {
                      // cityvalue=widget.city;
                      cityvalue;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: TextFormField(
                    style: TextStyle(fontSize: 14),
                    keyboardType: TextInputType.number,
                    controller: zipController,
                    decoration: ThemeHelper()
                        .textInputDecoration('Zip Code', 'Enter your zip code'),
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(height: 15),
                //--------------------------------here is title
                Container(
                  child: TextFormField(
                    controller: websiteController,
                    decoration: ThemeHelper().textInputDecoration(
                        'Website', 'Enter your website link'),
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: TextFormField(
                    controller: facebookController,
                    decoration: ThemeHelper().textInputDecoration(
                        'Facebook', 'Enter your facebook link'),
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: TextFormField(
                    controller: linkedinController,
                    decoration: ThemeHelper().textInputDecoration(
                        'Linkedin', 'Enter your linkedin link'),
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
