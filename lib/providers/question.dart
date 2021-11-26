import 'package:flutter/cupertino.dart';

class Question with ChangeNotifier {
  List _questions = [];
  List _bookMarkedQuestions = [];
  List _correctAnsweredQuestions = [];
  List _incorrectAnsweredQuestions = [];

  void addQuestions(List allQuestions) {
    _questions.add(allQuestions[0]); // = allQuestions;
    print("All questions have been added!");
    // print(_questions);
    // notifyListeners();
  }

  List get getAllQuestions => _questions;

  Map getQuestion(int index) {
    return _questions[index];
  }

  void updateQuestion() {
    notifyListeners();
    print("Listeners notified!");
  }

  void answerQuestion(int index, String selectedOption) {
    print(_questions);
    // String selectedAnswer = "";
    // switch (selectedOption) {
    //   case "Answer.A":
    //     selectedAnswer = "option1";
    //     break;
    //   case "Answer.B":
    //     selectedAnswer = "option2";
    //     break;
    //   case "Answer.C":
    //     selectedAnswer = "option3";
    //     break;
    //   case "Answer.D":
    //     selectedAnswer = "option4";
    //     break;
    // }
    // print(selectedAnswer);
    // print(_questions[index]["data"]["solutions"]["correctOption"]);
    // if (selectedAnswer == _questions[index]["data"]["solutions"]["correctOption"]) {
    //   _correctAnsweredQuestions.add(_questions[index]["questionId"]);
    //   print("correct answer!");
    // } else {
    //   Map wrongAnswer = {
    //     "index": index.toString(),
    //     "correctOption": _questions[index]["data"]["solutions"]["correctOption"],
    //     "selectedOption": selectedAnswer,
    //   };
    //   _incorrectAnsweredQuestions.add(wrongAnswer);
    //   print("wrong answer!");
    // }
  }

  void bookmarkAdd(int index) {
    _bookMarkedQuestions.add(_questions[index]);
  }

  void bookMarkRemove(int index) {
    _bookMarkedQuestions.remove(_questions[index]);
  }
}
