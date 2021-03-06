import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snailmail/Services/Authenticate.dart';

//flutter run -d 81e5c67a

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Color mainColor = Color(0xFF04c3cb);
  Color secondColor = Color(0xFF121212);
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Image(
              image: AssetImage("assets/conch.png"),
              width: 40,
              height: 40,
            ),
            SizedBox(height: 160),
            GestureDetector(
              onTap: () {
                setState(() {
                  isTapped = true;
                });
                AuthMethods().googleSignIn(context);
                setState(() {
                  isTapped = false;
                });
              },
              child: Container(
                height: 60,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: mainColor),
                child: Center(
                    child: Text(
                  "Sign in",
                  style: GoogleFonts.ubuntu(
                      fontSize: 30, letterSpacing: 6, color: secondColor),
                )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            Text(
              "By Minsaf",
              style: GoogleFonts.ubuntu(color: mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
