import 'package:flutter/cupertino.dart';

class Question with ChangeNotifier {
  List _questions = [];
  List _bookMarkedQuestions = [];
  List _correctAnsweredQuestions = [];
  List _incorrectAnsweredQuestions = [];

  void addQuestions(List allQuestions) {
    if (_questions.length == 0) {
      _questions.add(allQuestions); // = allQuestions;
      print("All questions have been added!");
    }
  }

  List get getAllQuestions => _questions;

  Map getQuestion(int index) {
    return _questions[index];
  }

  List get getCorrectAnsweredQuestions => _correctAnsweredQuestions;

  List get getIncorrectAnsweredQuestions => _incorrectAnsweredQuestions;

  bool checkIfAnswered(String id) {
    if (_correctAnsweredQuestions.contains(id)) {
      return true;
    } else {
      for (int i = 0; i < _incorrectAnsweredQuestions.length; i++) {
        if (_incorrectAnsweredQuestions[i]["questionId"] == id) {
          return true;
        }
      }
    }
    return false;
  }

  bool checkIfAnsweredCorrect(String id) {
    if (_correctAnsweredQuestions.contains(id)) {
      return true;
    }
    return false;
  }

  Map checkIfAnsweredWrong(String id) {
    for (int i = 0; i < _incorrectAnsweredQuestions.length; i++) {
      if (_incorrectAnsweredQuestions[i]["questionId"] == id) {
        return {
          "questionId": id,
          "index": _incorrectAnsweredQuestions[i]["index"],
          "correctOption": _incorrectAnsweredQuestions[i]["correctOption"],
          "selectedOption": _incorrectAnsweredQuestions[i]["selectedOption"],
        };
      }
    }
    return {};
  }

  void updateQuestion() {
    notifyListeners();
    print("Listeners notified!");
  }

  void answerQuestion(int index, String selectedOption) {
    String selectedAnswer = "";
    switch (selectedOption) {
      case "Answer.A":
        selectedAnswer = "option1";
        break;
      case "Answer.B":
        selectedAnswer = "option2";
        break;
      case "Answer.C":
        selectedAnswer = "option3";
        break;
      case "Answer.D":
        selectedAnswer = "option4";
        break;
    }
    print(selectedAnswer);
    print(_questions[0][index]["data"]["solutions"]["correctOption"]);
    if (selectedAnswer == _questions[0][index]["data"]["solutions"]["correctOption"]) {
      _correctAnsweredQuestions.add(_questions[0][index]["questionId"]);
      print("correct answer! Now the list contains: ");
      print(_correctAnsweredQuestions);
    } else {
      Map wrongAnswer = {
        "questionId": _questions[0][index]["questionId"],
        "index": index,
        "correctOption": _questions[0][index]["data"]["solutions"]["correctOption"],
        "selectedOption": selectedAnswer,
      };
      _incorrectAnsweredQuestions.add(wrongAnswer);
      print("wrong answer! Now the list contains: ");
      print(_incorrectAnsweredQuestions);
    }
  }

  void bookmarkAdd(int index) {
    _bookMarkedQuestions.add(_questions[index]);
  }

  void bookMarkRemove(int index) {
    _bookMarkedQuestions.remove(_questions[index]);
  }
}
