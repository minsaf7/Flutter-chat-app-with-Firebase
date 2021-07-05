import 'package:flutter/material.dart';
import 'package:snailmail/HelperFunctions/sharedPref.dart';

class Chat extends StatefulWidget {
  final String username;
  final String name;

  const Chat({Key? key, required this.username, required this.name})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Color mainColor = Color(0xFF04c3cb);
  Color secondColor = Color(0xFF121212);
  String? chatRoomId;
  String messageID = "";
  TextEditingController messageTestField = TextEditingController();

  String? myName, myprofilePic, myUsername, myEmail;

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

    chatRoomId = getChatWithUserID(widget.username, myUsername!);
    print(chatRoomId);
  }

  getChatWithUserID(String chatUserID, String myUserID) {
    if (chatUserID.substring(0, 1).codeUnitAt(0) >
        myUserID.substring(0, 1).codeUnitAt(0)) {
      return "$myUserID\_$chatUserID";
    } else {
      return "$chatUserID\_$myUserID";
    }
  }

  getAndSendMesages() async {}
  runOnLuanch() async {
    await getMyInforFromSharedPrferences();
    getAndSendMesages();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getMyInforFromSharedPrferences();
    runOnLuanch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                "https://www.kolpaper.com/wp-content/uploads/2020/02/whatsapp-wallpaper.jpg"),
          ),
        ),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[850],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageTestField,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type here",
                            hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                      )),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.send),
                        color: mainColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
