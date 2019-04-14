import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class FirestoreProvider {
  SharedPreferences prefs;
  Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", user.uid);
    print('-------------------> uid: ${prefs.getString('uid')}');
    // try {
    //   Fluttertoast.showToast(
    //       msg: "Welcome, ${user.displayName}!",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIos: 1,
    //       backgroundColor: Colors.blueGrey,
    //       textColor: Colors.white,
    //       fontSize: 14.0);
    // } catch (e) {
    //   print("e-message: " + e.message);
    //   Fluttertoast.showToast(
    //       msg: e.message,
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIos: 1,
    //       backgroundColor: Colors.blueGrey,
    //       textColor: Colors.white,
    //       fontSize: 14.0);
    // }

    if (user != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection("users")
          .where("id", isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        Firestore.instance.collection("users").document(user.uid).setData({
          "id": user.uid,
          "username": user.displayName,
          "email": user.email,
          "profilePicture": user.photoUrl,
          "stockCodeList": [],
          "investorType": "",
          'resultUrl': "",
          "didQuiz": false
        });
      } else {
        // getUserModel(user.uid);

        // var userDoc = documents[0].data;
        // // print("Here is user json: $userDoc");
        // UserModel userModel = UserModel.fromFirebase(userDoc);
        // for (int i = 0; i < userModel.stockCodeList.length; i++) {
        //   var temp = await Firestore.instance
        //       .collection("stockCode")
        //       .where("stockCode", isEqualTo: userModel.stockCodeList[i])
        //       .getDocuments();
        //   var tempData = temp.documents[0].data;
        //   print(tempData);
        //   userModel.setStockList = tempData;
        // }
        // Stock(temp.documents[0].data);
      }

      // Fluttertoast.showToast(msg: "Login successful");
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      print("create user");
      if (user != null) {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", user.uid);
        print('-------------------> uid: ${prefs.getString('uid')}');
        // final QuerySnapshot result = await Firestore.instance
        //     .collection("users")
        //     .where("id", isEqualTo: user.uid)
        //     .getDocuments();
        // final List<DocumentSnapshot> documents = result.documents;
        // print(documents);
        // var userDoc = documents[0].data;
        // print("Here is user json: $userDoc");
        // UserModel userModel = UserModel.fromFirebase(userDoc);

        // getUserModel(user.uid);

        // Fluttertoast.showToast(
        //     msg: "Welcome, ${userModel.username}!",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIos: 1,
        //     backgroundColor: Colors.blueGrey,
        //     textColor: Colors.white,
        //     fontSize: 14.0);
        // Fluttertoast.showToast(msg: "Login successful");
      }
    } catch (e) {
      print("e-message: " + e.message);
    }
  }

  Future<int> signUp(String email, String password) async {
    print('$email , $password');
    try {
      FirebaseUser user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("in firestore provider: user is created.");
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = user.email.split('@')[0];
      userUpdateInfo.photoUrl =
          "https://firebasestorage.googleapis.com/v0/b/fanchat.appspot.com/o/business_avatar_man_businessman_profile_account_contact_person-512.png?alt=media&token=b9ed1227-9993-4be2-a1ae-2c4f3846e489";
      user.updateProfile(userUpdateInfo).then((user) {
        FirebaseAuth.instance.currentUser().then((user) {
          Firestore.instance.collection("users").document(user.uid).setData({
            "id": user.uid,
            "username": user.displayName,
            "email": user.email,
            "profilePicture": user.photoUrl,
            "stockCodeList": [],
            "investorType": "",
            'resultUrl': "",
            "didQuiz": false
          });
        }).catchError((e) {
          print(e + "1");
        });
      }).catchError((e) {
        print(e + "2");
      });
      return 1;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0);
      print(e.message + "3");
      return 0;
    }
  }

  Future<UserModel> getUserModel(String userID) async {
    print("------------> In getUserModel: $userID");
    final QuerySnapshot result = await Firestore.instance
        .collection("users")
        .where("id", isEqualTo: userID)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    print(documents);
    var userDoc = documents[0].data;
    print("Here is user json: $userDoc");
    UserModel userModel = UserModel.fromFirebase(userDoc);
    for (int i = 0; i < userModel.stockCodeList.length; i++) {
      var temp = await Firestore.instance
          .collection("stockCode")
          .where("stockCode", isEqualTo: userModel.stockCodeList[i])
          .getDocuments();
      var tempData = temp.documents[0].data;
      print(tempData);
      userModel.setStockList = tempData;
    }
    // Fluttertoast.showToast(
    //     msg: "Welcome, ${userModel.username}!",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIos: 1,
    //     backgroundColor: Colors.blueGrey,
    //     textColor: Colors.white,
    //     fontSize: 14.0);
    // var preferences = await SharedPreferences.getInstance();
    // String _id = preferences.getString('id');
    // final DocumentSnapshot snapshot =
    //     await _firestore.collection("users").document(_id).get();

    return userModel;
  }
}
