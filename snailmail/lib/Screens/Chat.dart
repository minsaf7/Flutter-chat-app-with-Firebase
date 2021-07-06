import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:snailmail/HelperFunctions/sharedPref.dart';
import 'package:snailmail/Services/Database.dart';

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

  late Stream? messageStream = Stream.empty();

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

  getChatWithUserID(String userOne, String userTwo) {
    // if (chatUserID.substring(0, 1).codeUnitAt(0) >
    //     myUserID.substring(0, 1).codeUnitAt(0)) {
    //   return "$myUserID\_$chatUserID";
    // } else {
    //   return "$chatUserID\_$myUserID";
    // }

    if (userOne.length > userTwo.length) {
      return "$userOne\_$userTwo";
    } else {
      return "$userTwo\_$userOne";
    }

    //user1 = 6 user 2 = 5
  }

  sendMessage(bool isSearchClicked) {
    if (messageTestField.text != "") {
      String message = messageTestField.text;

      var lastMessage = DateTime.now();

      Map<String, dynamic> messageInfo = {
        "message": message,
        "sendBy": myUsername,
        "ts": lastMessage,
        "imageURL": myprofilePic
      };

      //message ID
      if (messageID == "") {
        messageID = randomAlphaNumeric(12);
      }

      Databases()
          .sendMessage(chatRoomId!, messageID, messageInfo)
          .then((value) {
        Map<String, dynamic> messageInfo = {
          "lastMessage": message,
          "lastMessageSendBy": myUsername,
          "lastMessageTS": lastMessage
        };
        Databases().updateMessage(chatRoomId!, messageInfo);

        if (isSearchClicked) {
          //clearing the textfield after sending the message
          messageTestField.text = "";
          setState(() {});

          //make messageID to blank to get regenerated on the next message

          messageID = "";
          setState(() {});
        }
      });
    }
  }

  Widget messageTile(String message, bool sentByMe) {
    return Row(
      mainAxisAlignment:
          sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: sentByMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                : BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
            color: sentByMe ? mainColor : Colors.black,
          ),
          padding: EdgeInsets.all(15),
          child: Text(
            message,
            style: GoogleFonts.ubuntu(
                color: sentByMe ? secondColor : Colors.white),
          ),
        )
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  //shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 100),
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (builder, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return messageTile(
                        ds["message"], myUsername == ds["sendBy"]);
                  })
              : Center(child: CircularProgressIndicator());
        });
  }

  getAndSendMesages() async {
    messageStream = await Databases().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

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
                "https://i.pinimg.com/originals/8b/58/5f/8b585fb4a5c9fedbb899cfb0cf0331a7.jpg"),
          ),
        ),
        child: Stack(
          children: [
            chatMessages(),
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
                        // onChanged: (val) {
                        //   sendMessage(false);
                        //   print(val);

                        //   if (sendMessage(false)) {
                        //     messageTestField.text = "";
                        //     setState(() {});
                        //   }
                        // },

                        controller: messageTestField,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type here",
                            hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                      )),
                      IconButton(
                        onPressed: () {
                          sendMessage(true);
                        },
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
