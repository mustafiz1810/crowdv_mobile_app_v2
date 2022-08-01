import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/Exam/widget/quiz.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/Exam/widget/result.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';

class ExamPage extends StatefulWidget {
  final data;
  ExamPage({this.data});
  @override
  State<StatefulWidget> createState() {
    return _ExamPageState();
  }
}

class _ExamPageState extends State<ExamPage> {
  List<Map<String, int>> tempArray = [];
  List<String> array=[];
  var _questionIndex = 0;
  String optionName;

  void _answerQuestion(int id, int optionId, String opName) {
    var arr = {
      'question_id': id,
      'option_id': optionId,
    };
    tempArray.add(arr);
    array.add(opName);
    print(array);
    // print(tempArray);
    setState(() {
      _questionIndex = _questionIndex + 1;
      // print(widget.data[]);
    });
    // print(optionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              _questionIndex < widget.data.length
                  ? Quiz(
                      answerQuestion: _answerQuestion,
                      questionIndex: _questionIndex,
                      questions: widget.data,
                    ) //Quiz
                  : Result(
                      tempArray,
                      widget.data[0]['test_id'],
                      array
                    ),
            ],
          )), //Padding
    ); //MaterialApp
  }
}