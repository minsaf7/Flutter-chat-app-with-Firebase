import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snailmail/HelperFunctions/sharedPref.dart';
import 'package:snailmail/Screens/Home.dart';
import 'package:snailmail/Services/Database.dart';

class AuthMethods {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//getting currently logged in user
  getCurrentUser() async {
    return await firebaseAuth.currentUser;
  }

//signinig in with google
  googleSignIn(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential loggedUser = await auth.signInWithCredential(credential);

    User? userDetails = loggedUser.user;

    if (userDetails != null) {
      SharedPrefHelper().saveEmail(userDetails.email!);
      SharedPrefHelper().saveUserID(userDetails.uid);
      SharedPrefHelper().saveDisplayname(userDetails.displayName!);
      SharedPrefHelper().saveUserProfile(userDetails.photoURL!);

      Map<String, dynamic> data = {
        "username": userDetails.email!.replaceAll("@gmail.com", ""),
        "email": userDetails.email,
        "name": userDetails.displayName,
        "profileURL": userDetails.photoURL
      };
      SharedPrefHelper().saveUsername(data["username"]);

      Databases().addUser(userDetails.uid, data).then((value) => {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (builder) => Home()))
          });
    }
  }

  Future signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await firebaseAuth.signOut();
  }
}
