// ignore: file_names
// ignore_for_file: prefer_const_constructors, file_names
// ignore_for_file: prefer_const_constructors

import 'package:eduprac/database/user_database.dart';
import 'package:eduprac/models/user.dart';
import 'package:eduprac/questions%20screen/widgets/questionCard.dart';
import 'package:eduprac/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionsScreen extends StatefulWidget {
  static const routeName = "/questions-screen";

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  bool isLoading = true;
  late List<User> user;
  late var questions;

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
    CardController controller;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      Container(
                        height: h / 25,
                        child: Image.asset("assets/images/nav.png"),
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
                            child: TinderSwapCard(
                              // swipeUp: true,
                              // swipeDown: true,
                              orientation: AmassOrientation.BOTTOM,
                              totalNum: questions.length,
                              stackNum: 3,
                              swipeEdge: 4.0,
                              maxWidth: w * 0.9,
                              maxHeight: h * 0.9,
                              minWidth: w * 0.8,
                              minHeight: h / 2,
                              cardBuilder: (context, index) => QuestionCard(
                                index: index,
                                question: questions[index],
                              ),
                              cardController: controller = CardController(),
                              swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
                                /// Get swiping card's alignment
                                if (align.x < 0) {
                                  //Card is LEFT swiping
                                } else if (align.x > 0) {
                                  //Card is RIGHT swiping
                                }
                              },
                              swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                                /// Get orientation & index of swiped card!
                              },
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
