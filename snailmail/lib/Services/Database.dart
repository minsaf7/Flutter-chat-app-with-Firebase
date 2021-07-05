import 'package:cloud_firestore/cloud_firestore.dart';

class Databases {
  //uploading user details to firestore
  Future addUser(String userId, Map<String, dynamic> userinfo) async {
    print(userinfo);
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userinfo);
  }

//searching user
  Future<Stream<QuerySnapshot>> searchUser(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: username)
        .snapshots();
  }

//sending messages
  Future sendMessage(String chatRoomId, String messageID,
      Map<String, dynamic> messageInfo) async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageID)
        .set(messageInfo);
  }

  updateMessage(String chatroomID, Map<String, dynamic> message) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .update(message);
  }

  createChatRoom(String chatRoomID, Map<String, dynamic> chatUsers) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomID)
        .get();

    if (snapShot.exists) {
      //chat room already exists
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomID)
          .set(chatUsers);
    }
  }
}
