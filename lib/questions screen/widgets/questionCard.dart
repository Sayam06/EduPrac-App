// ignore_for_file: file_names
import 'package:eduprac/providers/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class QuestionCard extends StatefulWidget {
  Map question;
  int index;

  QuestionCard({
    required this.question,
    required this.index,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

enum Answer { A, B, C, D, E }

class _QuestionCardState extends State<QuestionCard> {
  // late final AnimationController _controller = AnimationController(
  late Answer? _ans = Answer.E;
  late bool isCorrectlyAnswered;
  late Map incorrectAnswerDetails;
  //   duration: const Duration(seconds: 2),
  //   vsync: this,
  // )..repeat(reverse: false);
  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.easeIn,
  // );

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

//   late AnimationController controller;
//   late Animation<double> animation;

//   initState() {
//     super.initState();
//     controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
//     animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

//     /*animation.addStatusListener((status) {
//     if (status == AnimationStatus.completed) {
//       controller.reverse();
//     } else if (status == AnimationStatus.dismissed) {
//       controller.forward();
//     }
//   });*/
// //this will start the animation
//     controller.forward();
//   }

  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<Question>(context, listen: false);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    if (questionProvider.checkIfAnswered(widget.question["questionId"])) {
      if (questionProvider.checkIfAnsweredCorrect(widget.question["questionId"])) {
        isCorrectlyAnswered = true;
        print("question is correctly answered!");
      } else {
        isCorrectlyAnswered = false;
        incorrectAnswerDetails = questionProvider.checkIfAnsweredWrong(widget.question["questionId"]);
        print("question is incorrectly answered!");
        print(incorrectAnswerDetails);
      }
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Color.fromRGBO(166, 186, 198, 1),
          width: 6,
        ),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            right: w / 10,
            top: -h / 400,
            child: Container(
              height: h / 20,
              child: Image.asset(
                "assets/images/bookmark_unselected.png",
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: w / 12, right: w / 12),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: h / 20,
                            ),
                            label("Question ${widget.index + 1}", h, w),
                            Container(
                              margin: EdgeInsets.only(top: h / 50),
                              child: Html(
                                data: "${widget.question["detailedQuestion"]}",
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(h / 45),
                                    fontFamily: "Poppins",
                                    lineHeight: LineHeight(h / 520),
                                  )
                                },
                              ),
                            ),
                            SizedBox(
                              height: h / 20,
                            ),
                            label("Options: ", h, w),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Radio(
                                  value: Answer.A,
                                  groupValue: _ans,
                                  onChanged: (Answer? value) {
                                    setState(() {
                                      _ans = value;
                                    });
                                  },
                                ),
                                optionText("${widget.question["data"]["options"]["option1"]}", h, w),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Radio(
                                  value: Answer.B,
                                  groupValue: _ans,
                                  onChanged: (Answer? value) {
                                    setState(() {
                                      _ans = value;
                                    });
                                  },
                                ),
                                optionText("${widget.question["data"]["options"]["option2"]}", h, w),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Radio(
                                  value: Answer.C,
                                  groupValue: _ans,
                                  onChanged: (Answer? value) {
                                    setState(() {
                                      _ans = value;
                                    });
                                  },
                                ),
                                optionText("${widget.question["data"]["options"]["option3"]}", h, w),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Radio(
                                  value: Answer.D,
                                  groupValue: _ans,
                                  onChanged: (Answer? value) {
                                    setState(() {
                                      _ans = value;
                                    });
                                  },
                                ),
                                optionText("${widget.question["data"]["options"]["option4"]}", h, w),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                questionProvider.answerQuestion(widget.index, _ans.toString());
                                _ans = Answer.E;
                                // print(widget.tempquestionProvider.ans);
                                // print();
                                // widget.tempquestionProvider.answerQuestion(widget.index, _ans.toString());
                              },
                              child: Text("Check ans"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container label(String text, var h, var w) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Quicksand",
          color: Color.fromRGBO(253, 139, 139, 1),
          fontSize: h / 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container optionText(String text, var h, var w) {
    return Container(
      width: w / 1.7,
      margin: EdgeInsets.symmetric(vertical: h / 80),
      child: Html(
        data: text,
        style: {
          "body": Style(
            fontSize: FontSize(h / 45),
            fontFamily: "Poppins",
          )
        },
      ),
    );
  }
}
