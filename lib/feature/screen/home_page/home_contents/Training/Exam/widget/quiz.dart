import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';

import 'answer.dart';
import 'question.dart';

class Quiz extends StatelessWidget {
  final questions;
  final int questionIndex;
  final Function answerQuestion;

  Quiz({
    this.questions,
    this.answerQuestion,
    this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Question Answered: ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      questionIndex.toString() +
                          "/" +
                          questions.length.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: primaryColor),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Question(
                    questions[questionIndex]['question'],
                  ),
                  Divider(
                    height: 5,
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 40,
                    child: Center(
                        child: Text(
                      "Select the right answer from below, ",
                      style: TextStyle(color: Colors.white),
                    )),
                  ), //Question
                  ...(questions[questionIndex]['options']).map((answer) {
                    return Answer(
                        () => answerQuestion(
                            answer['question_id'], answer['id'],answer['option_name']),
                        answer['option_name']);
                  }).toList()
                ],
              ),
            ),
          ),
        ),
      ],
    ); //Column
  }
}
