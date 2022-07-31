import 'dart:convert';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  final List<Map<String, int>> answer;
  final int id;
  final List<String> array;

  Result(this.answer, this.id, this.array);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String token = "";

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  submit(testId, List<Map<String, int>> answer) async {
    String body = json.encode({'test_id': testId, 'question': answer});
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL +
              'get-participate-to-test/${widget.id}'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
        setState(() {});
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => HomeScreen()),
        //         (Route<dynamic> route) => false);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      }
    } catch (e) {
      setState(() {
        print(e);
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                TextButton(
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.answer[0].toString(),
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          // Text(
          //   'Score ' '${widget.result}',
          //   style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          //   textAlign: TextAlign.center,
          // ), submit(widget.id, widget.answer);//Text
          FlatButton(
            child: Text(
              'Claim Certificate!',
            ), //Text
            textColor: Colors.blue,
            onPressed: () {},
          ), //FlatButton
        ], //<Widget>[]
      ), //Column
    ); //Center
  }
}
