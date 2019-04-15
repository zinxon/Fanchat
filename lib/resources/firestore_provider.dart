import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/stock_model.dart';

class FirestoreProvider {
  SharedPreferences prefs;
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
    String uid = prefs.getString('uid');
    // print('-------------------> uid: $uid}');
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
          "stockList": [],
          "investorType": "",
          'resultUrl': "",
          "didQuiz": false
        });
      }
      getUserModel(uid);
    }
    Fluttertoast.showToast(
        msg: "Welcome, ${user.displayName}!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 14.0);
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
      if (user != null) {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", user.uid);
        String uid = prefs.getString('uid');
        // print('-------------------> uid: $uid');
        getUserModel(uid);
        Fluttertoast.showToast(
            msg: "Welcome, ${user.displayName}!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 14.0);
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
            "stockList": [],
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

  Future<UserModel> getUserModel(String uid) async {
    // print("------------> In getUserModel: $uid");
    final QuerySnapshot result = await Firestore.instance
        .collection("users")
        .where("id", isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    var userDoc = documents[0].data;
    UserModel userModel = UserModel.fromFirebase(userDoc);
    return userModel;
  }

  Future<void> addStock(String uid, String stockCode) async {
    var temp = await Firestore.instance
        .collection("stockCode")
        .where("stockCode", isEqualTo: stockCode)
        .getDocuments();
    var tempData = temp.documents[0].data;
    print(tempData.toString());
    List stock = [
      {
        'stockCode': tempData['stockCode'],
        'stockName': tempData['name'],
        'discribe': tempData['discribe'],
        'employees': tempData['employees'],
        'industry': tempData['industry'],
        'sector': tempData['sector'],
        'website': tempData['website']
      }
    ];
    Firestore.instance.collection("users").document(uid).updateData({
      "stockList": FieldValue.arrayUnion(stock),
    });
  }

  Future delStock(UserModel userModel, int index) async {
    prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    List<Stock> _modifiedStockList = userModel.stockList;
    List<Map> _modifiedStockListMap = List();
    Stock delStock = _modifiedStockList.removeAt(index);
    for (var item in _modifiedStockList) {
      _modifiedStockListMap.add(item.toMap());
    }
    print('--------------------->' + _modifiedStockListMap.toString());
    Firestore.instance
        .collection("users")
        .document("${userModel.id}")
        .updateData({
      "stockList": _modifiedStockListMap,
    }).whenComplete(() {
      Fluttertoast.showToast(msg: "已取消關注${delStock.stockName} ");
      getUserModel(uid);
    });
  }
}
