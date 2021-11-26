// ignore: file_names
// ignore_for_file: prefer_const_constructors, file_names
// ignore_for_file: prefer_const_constructors

import 'package:eduprac/database/user_database.dart';
import 'package:eduprac/models/user.dart';
import 'package:eduprac/providers/question.dart';
import 'package:eduprac/questions%20screen/questionDrawer.dart';
import 'package:eduprac/questions%20screen/widgets/questionCard.dart';
import 'package:eduprac/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';

class QuestionsScreen extends StatefulWidget {
  static const routeName = "/questions-screen";

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = true;
  int currentIndex = 0;
  int jumpTo = 0;
  late List<User> user;
  late var questions;

  void nextQuestion() {
    if (currentIndex != 29) {
      currentIndex = currentIndex + 1;
    }
  }

  void previousQuestion() {
    if (currentIndex != 0) {
      currentIndex = currentIndex - 1;
    }
  }

  void jump(int result) {
    currentIndex = result - 1;
    setState(() {});
  }

  Future getData() async {
    final String url = URL + "/temp";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "userid": user[0].typeId.toString(),
      },
    );
    questions = json.decode(response.body);
    setState(() {
      isLoading = false;
    });
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    this.user = await UserDatabase.instance.readAllUsers();
    getData();
  }

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final questionsData = Provider.of<Question>(context);
    if (!isLoading) {
      questionsData.addQuestions(questions);
      print("outside widget tree");
      print(Provider.of<Question>(context, listen: false).getAllQuestions);
    }

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Consumer<Question>(
        builder: (ctx, questionsData, _) => QuestionDrawer(
          questionNumber: currentIndex + 1,
          jump: jump,
        ),
      ),
      backgroundColor: Color.fromRGBO(51, 66, 87, 1),
      body: isLoading == false
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: w / 35),
              child: Column(
                children: [
                  SizedBox(
                    height: h / 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState!.openDrawer(),
                        child: Container(
                          height: h / 25,
                          child: Image.asset("assets/images/nav.png"),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Need help?",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            color: Color.fromRGBO(166, 186, 198, 1),
                            fontSize: h / 35,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: h / 25,
                  ),
                  Container(
                    height: h / 1.35,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ChangeNotifierProvider(
                              create: (ctx) => Question(),
                              child: Consumer<Question>(
                                  builder: (ctx, questionsData, _) => SwipeDetector(
                                        child: QuestionCard(
                                          question: questions[currentIndex],
                                          index: currentIndex,
                                          tempquestionProvider: questionsData,
                                        ),
                                        onSwipeLeft: () {
                                          print("inside widget tree");
                                          print(Provider.of<Question>(context, listen: false).getAllQuestions);
                                          previousQuestion();
                                          questionsData.updateQuestion();
                                        },
                                        onSwipeRight: () {
                                          nextQuestion();
                                          questionsData.updateQuestion();
                                        },
                                      )),
                            ),
                          ),
                        ),
                        // ElevatedButton(onPressed: () {}, child: Text("hello"))
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(84, 110, 125, 1),
              ),
            ),
    );
  }
}
