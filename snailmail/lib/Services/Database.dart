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

  Future<Stream<QuerySnapshot>> searchUser(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: username)
        .snapshots();
  }
}
