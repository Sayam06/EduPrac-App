// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class QuestionCard extends StatelessWidget {
  Map question;
  int index;

  QuestionCard({
    required this.question,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
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
              child: Image.asset("assets/images/bookmark_unselected.png"),
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
                            label("Question ${index + 1}", h, w),
                            Container(
                                margin: EdgeInsets.only(top: h / 50),
                                child: Html(
                                  data: "${question["detailedQuestion"]}",
                                  // style: {
                                  //   " ": Style(
                                  //     fontSize: FontSize.rem(50),
                                  //   )
                                  // },
                                )

                                // Text(
                                //   "${question["detailedQuestion"]}",
                                //   style: TextStyle(fontSize: h / 50),
                                // ),
                                ),
                            SizedBox(
                              height: h / 20,
                            ),
                            label("Options: ", h, w),
                            optionText("${question["data"]["options"]["option1"]}", h, w),
                            optionText("${question["data"]["options"]["option2"]}", h, w),
                            optionText("${question["data"]["options"]["option3"]}", h, w),
                            optionText("${question["data"]["options"]["option4"]}", h, w),
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
      margin: EdgeInsets.symmetric(vertical: h / 80),
      child: Text(
        text,
      ),
    );
  }
}
