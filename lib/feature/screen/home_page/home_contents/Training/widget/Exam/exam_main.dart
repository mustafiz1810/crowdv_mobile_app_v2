import 'dart:convert';

import 'package:crowdv_mobile_app/data/models/volunteer/exam_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/widget/Exam/widget/answer.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExamPage extends StatefulWidget {
  final id;
  ExamPage({this.id});
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

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

  Future<ExamModel> getExamApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'question/list/${widget.id}'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());

    showToast(context, data['message']);
    if (response.statusCode == 200) {
      return ExamModel.fromJson(data);
    } else {
      return ExamModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Exam',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<ExamModel>(
                future: getExamApi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Given answer",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    '${_totalScore.toString()}/${snapshot.data.data.questions.length}',
                                    style: TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // if (_scoreTracker.length == 0)
                                //   SizedBox(
                                //     height: 25.0,
                                //   ),
                                // if (_scoreTracker.length > 0) ..._scoreTracker
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: double.infinity,
                              height: 130.0,
                              margin: EdgeInsets.only(
                                  bottom: 10.0, left: 30.0, right: 30.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "Q# " +
                                    snapshot
                                        .data.data.questions[index].question,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // ListView.builder(
                            //   itemCount: snapshot.data.data.questions.length,
                            //   itemBuilder: (context, position) {
                            //     return Expanded(
                            //       child: Answer(
                            //         answerText: snapshot.data.data.questions[index].options[position].optionName,
                            //         answerColor: answerWasSelected
                            //             ? Colors.green
                            //             : Colors.red,
                            //         answerTap: () {
                            //           // if answer was already selected then nothing happens onTap
                            //           if (answerWasSelected) {
                            //             return;
                            //           }
                            //           //answer is being selected
                            //           _questionAnswered(true);
                            //         },
                            //       ),
                            //     );
                            //   }
                            //     ),
                            ListView.builder(
                                itemCount: snapshot
                                    .data.data.questions[index].options.length,
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Answer(
                                    answerText: snapshot
                                        .data
                                        .data
                                        .questions[index]
                                        .options[position]
                                        .optionName,
                                    answerColor: answerWasSelected
                                        ? Colors.green
                                        : Colors.white,
                                    answerTap: () {
                                      // if answer was already selected then nothing happens onTap
                                      if (answerWasSelected) {
                                        print(snapshot
                                            .data
                                            .data
                                            .questions[index]
                                            .options[position]
                                            .optionName);
                                      }
                                      //answer is being selected
                                      _questionAnswered(true);
                                    },
                                  );
                                }),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 40.0),
                              ),
                              onPressed: () {
                                if (!answerWasSelected) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Please select an answer before going to the next question'),
                                  ));
                                  return;
                                }
                                _nextQuestion();
                              },
                              child: Text(
                                  endOfQuiz ? 'Restart Quiz' : 'Next Question'),
                            ),
                            if (answerWasSelected && !endOfQuiz)
                              Container(
                                height: 100,
                                width: double.infinity,
                                color: correctAnswerSelected
                                    ? Colors.green
                                    : Colors.red,
                                child: Center(
                                  child: Text(
                                    correctAnswerSelected
                                        ? 'Well done, you got it right!'
                                        : 'Wrong :/',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            if (endOfQuiz)
                              Container(
                                height: 100,
                                width: double.infinity,
                                color: Colors.black,
                                child: Center(
                                  child: Text(
                                    _totalScore > 4
                                        ? 'Congratulations! Your final score is: $_totalScore'
                                        : 'Your final score is: $_totalScore. Better luck next time!',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: _totalScore > 4
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                          ],
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
                        subTitle: 'No Test available',
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
        ));
  }
}

final _questions = const [
  {
    'question': 'How long is New Zealand’s Ninety Mile Beach?',
    'answers': [
      {'answerText': '88km, so 55 miles long.', 'score': true},
      {'answerText': '55km, so 34 miles long.', 'score': false},
      {'answerText': '90km, so 56 miles long.', 'score': false},
    ],
  },
  {
    'question':
        'In which month does the German festival of Oktoberfest mostly take place?',
    'answers': [
      {'answerText': 'January', 'score': false},
      {'answerText': 'October', 'score': false},
      {'answerText': 'September', 'score': true},
    ],
  },
  {
    'question': 'Who composed the music for Sonic the Hedgehog 3?',
    'answers': [
      {'answerText': 'Britney Spears', 'score': false},
      {'answerText': 'Timbaland', 'score': false},
      {'answerText': 'Michael Jackson', 'score': true},
    ],
  },
  {
    'question': 'In Georgia (the state), it’s illegal to eat what with a fork?',
    'answers': [
      {'answerText': 'Hamburgers', 'score': false},
      {'answerText': 'Fried chicken', 'score': true},
      {'answerText': 'Pizza', 'score': false},
    ],
  },
  {
    'question':
        'Which part of his body did musician Gene Simmons from Kiss insure for one million dollars?',
    'answers': [
      {'answerText': 'His tongue', 'score': true},
      {'answerText': 'His leg', 'score': false},
      {'answerText': 'His butt', 'score': false},
    ],
  },
  {
    'question': 'In which country are Panama hats made?',
    'answers': [
      {'answerText': 'Ecuador', 'score': true},
      {'answerText': 'Panama (duh)', 'score': false},
      {'answerText': 'Portugal', 'score': false},
    ],
  },
  {
    'question': 'From which country do French fries originate?',
    'answers': [
      {'answerText': 'Belgium', 'score': true},
      {'answerText': 'France (duh)', 'score': false},
      {'answerText': 'Switzerland', 'score': false},
    ],
  },
  {
    'question': 'Which sea creature has three hearts?',
    'answers': [
      {'answerText': 'Great White Sharks', 'score': false},
      {'answerText': 'Killer Whales', 'score': false},
      {'answerText': 'The Octopus', 'score': true},
    ],
  },
  {
    'question': 'Which European country eats the most chocolate per capita?',
    'answers': [
      {'answerText': 'Belgium', 'score': false},
      {'answerText': 'The Netherlands', 'score': false},
      {'answerText': 'Switzerland', 'score': true},
    ],
  },
];
