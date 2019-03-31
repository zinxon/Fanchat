import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  Future<FirebaseUser> _firebaseUser = FirebaseAuth.instance.currentUser();

  static GlobalKey screen = new GlobalKey();

  String currentUrl =
      "https://www.apesk.com/mbti/submit_email_date_cx_m.asp?code=219.73.34.161&user=20944310";
  // String currentUrl = "";
  bool isDone = false;

  // var urlString = "https://www.apesk.com/mbti/dati.asp";
  var urlString =
      "https://www.apesk.com/mbti/submit_email_date_cx_m.asp?code=219.73.34.161&user=20944310";

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
      // currentUrl = wvs.url;
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

  takeScreenShot() async {
    RenderRepaintBoundary boundary = screen.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    // final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    print("path:" + tempPath);
    File imgFile = new File('$tempPath/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imgFile);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    String text = visionText.text;
    String pattern = r"^[A-Z]";
    RegExp regEx = RegExp(pattern);

    String type = "Couldn't find any mail in the foto! Please try again!";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        // if (regEx.hasMatch(line.text)) {
        //   type = line.text;
        // }
        type = line.text;
      }
    }
    print("vision:" + type);
    print("hihi");
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
        takeScreenShot();
        Fluttertoast.showToast(
            msg: "MBTI測試分析完畢，正在截圖並將分析結果上傳到Firebase",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 14.0);
        // Navigator.pop(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => AppHolder(
        //             indexGlobal: 1,
        //           )),
        // );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: RepaintBoundary(
          key: screen,
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
              ),
        ));
  }
}
