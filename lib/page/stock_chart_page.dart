import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StockChartPage extends StatefulWidget {
  final String urlString;

  StockChartPage({Key key, this.urlString}) : super(key: key);
  @override
  _StockChartPageState createState() => _StockChartPageState();
}

class _StockChartPageState extends State<StockChartPage> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  Future<FirebaseUser> _firebaseUser = FirebaseAuth.instance.currentUser();

  // String currentUrl =
  //     "https://www.apesk.com/mbti/submit_email_date_cx_m.asp?code=219.73.34.161&user=20944310";
  // // String currentUrl = "";
  // bool isDone = false;

  // var urlString = "https://www.apesk.com/mbti/dati.asp";

  launchUrl() {
    setState(() {
      flutterWebviewPlugin.reloadUrl(widget.urlString);
    });
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      print(wvs.type);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: WebviewScaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.urlString),
            ),
            initialChild: Center(
              child: CircularProgressIndicator(),
            ),
            url: widget.urlString,
            enableAppScheme: true
            // hidden: false,
            ));
  }
}
