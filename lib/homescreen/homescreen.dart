// ignore_for_file: prefer_const_constructors

import 'package:eduprac/database/user_database.dart';
import 'package:eduprac/google_signin_api.dart';
import 'package:eduprac/launchScreen.dart';
import 'package:eduprac/models/user.dart';
import 'package:eduprac/questions%20screen/questionsScreen.dart';
import 'package:eduprac/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homescreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  late List<User> user;
  late int dailyObjective;
  late List<_PieData> pieData = [
    _PieData('Complete', dailyObjective, "test"),
    _PieData('Incomplete', dailyObjective >= 30 ? 0 : 30 - dailyObjective, "test"),
  ];

  Future getData() async {
    final String url = URL + "/getDaily";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "userid": user[0].typeId.toString(),
      },
    );
    print(response.body);
    dailyObjective = json.decode(response.body);
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
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 66, 87, 1),
      body: isLoading == false
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: w / 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Hey, ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w100,
                                  color: Color.fromRGBO(166, 186, 198, 1),
                                  fontSize: h / 35,
                                ),
                              ),
                              Text(
                                user[0].name!.substring(
                                      0,
                                      user[0].name!.indexOf(" "),
                                    ),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white,
                                  fontSize: h / 35,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: w / 30,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(360),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                border: Border.all(
                                  color: Color.fromRGBO(163, 165, 167, 1),
                                  width: 2,
                                ),
                                color: Colors.black,
                              ),
                              height: h / 21,
                              width: h / 21,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: Image.network(
                                  user[0].picture.toString(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h / 100,
                  ),
                  Container(
                    height: h / 4,
                    child: Stack(
                      children: [
                        SfCircularChart(
                          // backgroundColor: Colors.white,
                          margin: EdgeInsets.all(0),
                          centerX: "50%",
                          centerY: "50%",
                          series: <DoughnutSeries<_PieData, String>>[
                            DoughnutSeries<_PieData, String>(
                              explode: true,
                              explodeIndex: 0,
                              dataSource: pieData,
                              xValueMapper: (_PieData data, _) => data.xData,
                              yValueMapper: (_PieData data, _) => data.yData,
                              dataLabelMapper: (_PieData data, _) => data.text,
                              dataLabelSettings: DataLabelSettings(isVisible: false),
                              radius: (h / 10).toString(),
                              innerRadius: (h / 9).toString(),
                            ),
                          ],
                          palette: [Color.fromRGBO(253, 139, 139, 1), Colors.transparent],
                        ),
                        Positioned(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.circular(360),
                              // ),
                              // color: Colors.white,
                              margin: EdgeInsets.only(top: h / 50),
                              width: h / 5,
                              height: h / 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    "Daily Objective",
                                    style: TextStyle(
                                      fontFamily: "Pacifico",
                                      color: Color.fromRGBO(253, 139, 139, 1),
                                      fontSize: h / 40,
                                    ),
                                  ),
                                  SizedBox(
                                    height: h / 70,
                                  ),
                                  Text(
                                    "${dailyObjective}/30",
                                    style: TextStyle(
                                      fontFamily: "Fira Code",
                                      color: Colors.green,
                                      fontSize: h / 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h / 20,
                  ),
                  header(h, "Recommended"),
                  SizedBox(
                    height: h / 100,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Color.fromRGBO(166, 186, 198, 1),
                                width: 4,
                              )),
                          height: 100,
                          width: 170,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Color.fromRGBO(166, 186, 198, 1),
                                width: 4,
                              )),
                          height: 100,
                          width: 170,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: h / 100),
                  header(h, "Create Session"),
                  SizedBox(height: h / 100),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(QuestionsScreen.routeName),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 370,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Color.fromRGBO(166, 186, 198, 1),
                                  width: 4,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: h / 100),
                  header(h, "Statistics"),
                  SizedBox(height: h / 100),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 370,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Color.fromRGBO(166, 186, 198, 1),
                                width: 4,
                              )),
                        )
                      ],
                    ),
                  )
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

  Container header(double h, String text) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Poppins",
          color: Colors.white,
          fontSize: h / 38,
        ),
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text = ""]);
  final String xData;
  final num yData;
  final String text;
}
