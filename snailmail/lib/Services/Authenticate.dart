import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snailmail/HelperFunctions/sharedPref.dart';

class AuthMethods {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//getting currently logged in user
  getCurrentUser() {
    return firebaseAuth.currentUser;
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
    }
  }
}
