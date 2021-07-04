import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snailmail/Screens/SignIn.dart';
import 'package:snailmail/Services/Authenticate.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color mainColor = Color(0xFF04c3cb);
  Color secondColor = Color(0xFF121212);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats",
          style: GoogleFonts.ubuntu(),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Minsaf"),
            ),
            ElevatedButton(
              onPressed: () {
                AuthMethods().signout().then((e) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (builder) => SignIn()));
                });
              },
              child: Text("Log out"),
            )
          ],
        ),
      ),
      backgroundColor: secondColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          child: Column(
            children: [
              //search containet
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[850],
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),

                  //search textfield and search icon
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      Icon(Icons.search)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
