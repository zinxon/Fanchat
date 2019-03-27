import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_holder.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  Future<FirebaseUser> _firebaseUser = FirebaseAuth.instance.currentUser();

  // String currentUrl =
  //     "https://www.apesk.com/mbti/submit_email_date_cx_m.asp?code=219.73.34.161&user=20944310";
  String currentUrl = "";
  bool isDone = false;

  var urlString = "https://www.apesk.com/mbti/dati.asp";

  launchUrl() {
    setState(() {
      flutterWebviewPlugin.reloadUrl(urlString);
    });
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      print(wvs.type);
      currentUrl = wvs.url;
      print("Current Url: " + currentUrl);
      if (currentUrl.contains("user")) {
        setState(() {
          isDone = true;
        });
        Fluttertoast.showToast(
            msg: "已完成MBTI測試，請按右上方的完成按鈕",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.dispose();
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop(100);

    ///彈出頁面并傳回int值100，用于上一個界面的回調
    return Future.value(false);
  }

  Future<void> upload() async {
    try {
      if (currentUrl.contains("user") && _firebaseUser != null) {
        // final QuerySnapshot result = await Firestore.instance
        //     .collection("users")
        //     .where("id", isEqualTo: _firebaseUser.uid)
        //     .getDocuments();
        // final List<DocumentSnapshot> documents = result.documents;
        // Firestore.instance
        //     .collection("users")
        //     .document(_firebaseUser.uid)
        //     .updateData({
        //   "stockList": FieldValue.arrayUnion(stockList),
        // });
        _firebaseUser.then((user) {
          Firestore.instance
              .collection("users")
              .document(user.uid)
              .updateData({'resultUrl': currentUrl});
        }).catchError((e) {
          print(e);
        });
        Fluttertoast.showToast(
            msg: "MBTI測試分析完畢，正在截圖並將分析結果上傳到Firebase",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AppHolder(
                    indexGlobal: 1,
                  )),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: WebviewScaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("MBTI性格測試"),
              actions: <Widget>[
                isDone
                    ? IconButton(
                        icon: Icon(
                          FontAwesomeIcons.checkSquare,
                          color: Colors.black,
                          size: 25.0,
                        ),
                        onPressed: upload,
                      )
                    : Container()
              ],
            ),
            initialChild: Center(
              child: CircularProgressIndicator(),
            ),
            url: urlString,
            enableAppScheme: true
            // hidden: false,
            ));
  }
}
