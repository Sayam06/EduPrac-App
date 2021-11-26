// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class QuestionDrawer extends StatelessWidget {
  int questionNumber;
  Function jump;
  QuestionDrawer({required this.questionNumber, required this.jump});

  // QuestionDrawer({required this.questionNumber});
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: w / 10),
            // color: Colors.green,
            height: h / 2.2,
            // width: 200,
            // width: w / 1.5,
            // height: h / 3,
            // width: w / 10,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 4 / 3,
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if (index + 1 != questionNumber) {
                  return GestureDetector(
                    onTap: () {
                      jump(index + 1);
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ));
                }
              },
              itemCount: 30,
            ),
          ),
        ],
      ),
    );
  }
}
