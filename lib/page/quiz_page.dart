import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../style/theme.dart' show TextStyles;
import '../app_holder.dart';

class QuizPage extends StatefulWidget {
  final Widget child;

  QuizPage({Key key, this.child}) : super(key: key);

  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  UserModel _userModel = UserModel.instance;
  bool isDone = false;
  String _currentUrl;
  String _currentType;
  String _investorType = "保守型投資者";
  String urlS = 'https://www.apesk.com/mbti/dati_tw.asp';
  String testUrl =
      'https://www.apesk.com/mbti/submit_email_date_cx_m.asp?code=219.73.34.161&user=20944310';

  List _types = [
    "ISTJ 檢查員型",
    "ISTP 冒險家型",
    "ISFJ 照顧者型",
    "ISFP 藝術家型",
    // "INTJ 獨立自主型",
    "INTJ 專家型",
    "INTP 學者型",
    "INFJ 博愛型",
    "INFP 哲學家型",
    "ESTJ 管家型",
    "ESTP 挑戰型",
    "ESFJ 主人型",
    "ESFP 表演者型",
    "ENTJ 統帥型",
    "ENTP 智多星型",
    "ENFJ 教導型",
    "ENFP 公關型",
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String type in _types) {
      items.add(new DropdownMenuItem(value: type, child: new Text(type)));
    }
    return items;
  }

  void changedDropDownItem(String selectedType) {
    print("Selected type $selectedType");
    setState(() {
      _currentType = selectedType;
      if (_currentType.contains('S') && _currentType.contains("J")) {
        _investorType = "保守型投資者";
      } else if (_currentType.contains('S') && _currentType.contains("P")) {
        _investorType = "進取型投資者";
      } else if (_currentType.contains('N') && _currentType.contains("T")) {
        _investorType = "獨立型投資者";
      } else if (_currentType.contains('N') && _currentType.contains("F")) {
        _investorType = "增長型投資者";
      }
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("請確定選擇："),
          content: Text("$_currentType 判斷為 $_investorType"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("確定"),
              onPressed: () {
                upload();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppHolder(
                            indexGlobal: 1,
                          )),
                );
              },
            ),
            FlatButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void checkUrl(String url) {
    if (url.contains("user")) {
      setState(() {
        isDone = true;
        _currentUrl = url;
      });
      Fluttertoast.showToast(
          msg: "已完成MBTI測試，請選擇對應的類型並按右上方的完成按鈕",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  Future<void> upload() async {
    try {
      Firestore.instance
          .collection("users")
          .document(_userModel.id)
          .updateData({'resultUrl': _currentUrl});
      Firestore.instance
          .collection("users")
          .document(_userModel.id)
          .updateData({'investorType': _investorType});
      Firestore.instance
          .collection("users")
          .document(_userModel.id)
          .updateData({'didQuiz': true});
      Fluttertoast.showToast(
          msg: "MBTI測試分析完畢，正在截圖並將分析結果上傳到Firebase",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 14.0);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentType = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'MBTI性格測試',
          style: TextStyles.appBarTitle,
        ),
        centerTitle: true,
        actions: <Widget>[
          isDone
              ? Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 4.4),
                      child: DropdownButton(
                        value: _currentType,
                        items: _dropDownMenuItems,
                        onChanged: changedDropDownItem,
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.checkSquare,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        onPressed: _showDialog)
                  ],
                )
              : Container()
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: urlS,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            checkUrl(url);
          },
        );
      }),
    );
  }
}
