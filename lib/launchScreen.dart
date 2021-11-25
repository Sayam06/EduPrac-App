// ignore_for_file: prefer_const_constructors, file_names

import 'package:eduprac/database/user_database.dart';
import 'package:eduprac/google_signin_api.dart';
import 'package:eduprac/homescreen/homescreen.dart';
import 'package:eduprac/models/user.dart' as USER;
import 'package:eduprac/url.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LaunchScreen extends StatefulWidget {
  static const routeName = "/launchscreen";

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  int counter = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;
  late List<USER.User> user;

  Future postData(String? username, String? email, String? pictureAddress, String? typeId) async {
    final String url = URL + "/user";
    final response = await http.post(
      Uri.parse(url),
      body: {
        "userId": typeId,
        "username": username,
        "email": email,
        "photoURL": pictureAddress,
        "role": "USER",
        //"dailyObjective": 0,
      },
    );
    print(response.body);
    final user = USER.User(name: username, email: email, picture: pictureAddress, typeId: typeId);
    await UserDatabase.instance.create(user);

    //GO TO NEXT SCREEN!
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  Future signIn(BuildContext context) async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in Failed")));
    } else {
      setState(() {
        isLoading = true;
      });
      postData(user.displayName!, user.email, user.photoUrl, user.id);
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    this.user = await UserDatabase.instance.readAllUsers();
    if (!this.user.isEmpty && counter == 1) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    counter++;
    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 66, 87, 1),
      body: isLoading == false
          ? Stack(
              children: [
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: h / 2,
                      width: w,
                      child: Image.asset(
                        "assets/images/background.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: h / 1.8,
                      width: w / 1.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Color.fromRGBO(174, 174, 174, 1),
                          width: 6,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: h / 15, left: w / 15),
                            child: Text(
                              "Welcome",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Sulphur Point",
                                fontSize: h / 22, //35,
                                color: Color.fromRGBO(253, 139, 139, 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: h / 6,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: w / 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Login with",
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.bold,
                                      fontSize: h / 30,
                                      color: Color.fromRGBO(150, 150, 150, 1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: w / 25,
                                ),
                                GestureDetector(
                                  onTap: () => signIn(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(360),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(7),
                                    height: h / 20,
                                    child: Image.asset("assets/images/google_logo.png"),
                                  ),
                                ),
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: h / 500,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: h / 5, //150,
                                  child: Image.asset(
                                    "assets/images/login_graphic.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(84, 110, 125, 1),
              ),
            ),
    );
  }
}
