// ignore_for_file: prefer_const_constructors, file_names

import 'package:eduprac/google_signin_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future postData(String? username, String? email, String? pictureAddress, String? typeId) async {
    final String url = "https://eduprac.herokuapp.com/user"; ////phone: 192.168.128.196, ethernet:192.168.31.118
    final response = await http.post(
      Uri.parse(url),
      body: {
        "userId": typeId,
        "username": username,
        "email": email,
        "photoURL": pictureAddress,
        "role": "USER",
        // "questions": {
        //   "bookmarkedQuestions": [],
        //   "attemptedQuestions": [],
        // }
      },
    );
    print(response.body);
    // final user = db.User(name: username, email: email, photo: pictureAddress, type: type);
    // await UserDatabase.instance.create(user);

    // Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
  }

  Future signIn(BuildContext context) async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in Failed")));
    } else {
      // setState(() {
      //   isLoading = true;
      // });
      print(user.displayName);
      print(user.email);
      print(user.photoUrl);
      postData(user.displayName!, user.email, user.photoUrl, user.id);
    }
  }

  // Future refresh() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   this.user = await UserDatabase.instance.readAllUsers();
  //   if (!this.user.isEmpty && counter == 1) {
  //     Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   refresh();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Google sign in"),
              onPressed: () {
                signIn(context);
              },
            ),
            ElevatedButton(
              child: Text("Google sign out"),
              onPressed: () {
                GoogleSignInApi.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
