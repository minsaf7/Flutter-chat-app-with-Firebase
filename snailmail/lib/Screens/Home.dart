import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snailmail/HelperFunctions/sharedPref.dart';
import 'package:snailmail/Screens/Chat.dart';
import 'package:snailmail/Screens/SignIn.dart';
import 'package:snailmail/Services/Authenticate.dart';
import 'package:snailmail/Services/Database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color mainColor = Color(0xFF04c3cb);
  Color secondColor = Color(0xFF121212);

  FirebaseAuth auth = FirebaseAuth.instance;
  bool isSearchig = false;
  late Stream? usersStream = Stream.empty();

  TextEditingController search = TextEditingController();

  String? myName, myprofilePic, myUsername, myEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSearchig = false;
    getMyInforFromSharedPrferences();
    //usersStream;
  }

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
              child: CircleAvatar(
                  // backgroundImage: NetworkImage(photoURl!),
                  ),
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
              Row(
                children: [
                  isSearchig
                      ? Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearchig = false;
                                  search.clear();
                                });
                              },
                              icon: Icon(Icons.arrow_back)),
                        )
                      : Container(),
                  Expanded(
                    child: Container(
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
                                controller: search,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "username"),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (search.text != "") {
                                    onSearch();
                                  }
                                },
                                icon: Icon(Icons.search)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: mainColor,
                height: 2,
              ),

              isSearchig ? searchList() : chatRooms()
            ],
          ),
        ),
      ),
    );
  }

  onSearch() async {
    setState(() {
      isSearchig = true;
    });
    usersStream = await Databases().searchUser(search.text);

    //print("USER: " + usersStream.length.toString());]
  }

  Widget searchList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () {
                        print(documentSnapshot.id);
                        documentSnapshot.id;

                        var chatRoomId = getChatWithUserID(
                            documentSnapshot["username"], myUsername!);

                        Map<String, dynamic> chatUsers = {
                          "users": [myUsername, documentSnapshot["username"]]
                        };
                        Databases().createChatRoom(chatRoomId, chatUsers);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => Chat(
                                  username: documentSnapshot["username"],
                                  name: documentSnapshot["name"],
                                )));
                      },
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(documentSnapshot["profileURL"]),
                      ),
                      title: Text(documentSnapshot["name"]),
                      subtitle: Text(documentSnapshot["email"]),
                    ),
                  );
                })
            : CircularProgressIndicator();
      },
    );
  }

  chatRooms() {
    return Container(
      child: ListTile(),
    );
  }

  getChatWithUserID(String chatUserID, String myUserID) {
    if (chatUserID.substring(0, 1).codeUnitAt(0) >
        myUserID.substring(0, 1).codeUnitAt(0)) {
      return "$myUserID\_$chatUserID";
    } else {
      return "$chatUserID\_$myUserID";
    }
  }

  getMyInforFromSharedPrferences() async {
    SharedPrefHelper pref = SharedPrefHelper();
    // print("name");
    myName = await pref.getDisplayname();
    // print("pic");
    myprofilePic = await pref.getUserprofile();
    // print("username");
    myUsername = await pref.getUsername();
    // print("email");
    myEmail = await pref.getUserEmail();
    // print("done");

    print(myName);
    print(myEmail);
    print(myUsername);
    print(myprofilePic);
  }
}
