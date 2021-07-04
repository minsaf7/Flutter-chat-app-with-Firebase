import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snailmail/Screens/SignIn.dart';
import 'package:snailmail/Services/Authenticate.dart';

import 'Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogged = false;
  checkAuth() {
    return FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            setState(() {
              isLogged = true;
            });
            return Home();
          } else {
            setState(() {
              isLogged = false;
            });
            return SignIn();
          }
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      // if (AuthMethods().getCurrentUser() == null) {
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (builder) => SignIn()));
      // } else {
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (builder) => Home()));
      // }

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (builder) => SignIn()));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: Center(
        child: Image(
          image: AssetImage("assets/conch.png"),
          height: 80,
          width: 80,
        ),
      ),
    );
  }
}
