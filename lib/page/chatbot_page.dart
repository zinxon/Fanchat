import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app_holder.dart';
import '../api/yahoo_finance.dart';

FirebaseUser _firebaseUser;
String _username = "User";
String _photoUrl =
    'https://firebasestorage.googleapis.com/v0/b/fanchat.appspot.com/o/business_avatar_man_businessman_profile_account_contact_person-512.png?alt=media&token=b9ed1227-9993-4be2-a1ae-2c4f3846e489';

class ChatbotPage extends StatefulWidget {
  ChatbotPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

FlutterTts flutterTts;
String language;
String voice;

class _ChatbotPageState extends State<ChatbotPage>
    with AutomaticKeepAliveClientMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    initTts();
    FirebaseAuth.instance.currentUser().then((user) {
      _firebaseUser = user;
      setState(() {
        _photoUrl = _firebaseUser.photoUrl;
        _username = _firebaseUser.displayName;
      });
    }).catchError((e) {
      print(e);
    });
  }

  initTts() {
    flutterTts = FlutterTts();
    language = "yue-HK";
    voice = "yue-hk-x-jar-local";
    flutterTts.setLanguage(language);
    flutterTts.setVoice(voice);
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                autofocus: true,
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    //   InputDecoration.collapsed(hintText: "Send a message",),
                    InputDecoration(
                        hintText: "Send a message",
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/config/dialogflow.json").build();
    Dialogflow dialogflow = Dialogflow(
        authGoogle: authGoogle, language: Language.CHINESE_CANTONESE);
    AIResponse response = await dialogflow.detectIntent(query);
    ChatMessage message = ChatMessage(
      text: response.getMessage() ??
          CardDialogflow(response.getListMessage()[0]).title,
      name: "FanChat",
      type: false,
    );
    // print(response.getListMessage());
    if (response.queryResult.action == "add_stock") {
      print("action: " + response.queryResult.action);
      addStock(response);
    } else if (response.queryResult.action == "get_stock_ ") {
      List msg = response.getListMessage();
      String msgS = (msg[0]['text']['text'][0]).toString();
      if (msgS.contains("-")) {
        String stockCode = msgS.split("-")[0];
        getStockNew(stockCode);
      }
    }
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      name: _username,
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _response(text);
  }

  Future<bool> _requestPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AppHolder(
                  title: 'FacChat',
                )));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text("FanChat"),
            automaticallyImplyLeading: true,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.home),
              color: Colors.black,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppHolder(
                              title: 'FacChat',
                            )));
              },
            ),
          ),
          body: SafeArea(
              child: Scrollbar(
                  child: Column(children: <Widget>[
            Flexible(
                child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            )
          ])))),
    );
  }

  Future<Null> addStock(AIResponse res) async {
    List msg = res.getListMessage();
    String msgS = (msg[0]['text']['text'][0]).toString();
    if (msgS.contains("-")) {
      String stockCode = msgS.split("-")[1].substring(1);
      print("addStock: " + stockCode);
      List stockList = [stockCode];
      try {
        if (_firebaseUser != null) {
          final QuerySnapshot result = await Firestore.instance
              .collection("users")
              .where("id", isEqualTo: _firebaseUser.uid)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          Firestore.instance
              .collection("users")
              .document(_firebaseUser.uid)
              .updateData({
            "stockList": FieldValue.arrayUnion(stockList),
          });

          Fluttertoast.showToast(
              msg: "${stockCode} 已關注",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0, top: 20),
        child: CircleAvatar(
            child: Container(child: Image.asset("assets/img/fanchat.png"))),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(this.name, style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  color: Colors.black,
                  onPressed: () {
                    flutterTts.speak(text);
                  },
                ),
              ],
            ),
            Container(
              // margin: const EdgeInsets.only(top: 10.0),
              // child: Text(text),
              child: GestureDetector(
                child: CustomToolTip(
                  text: text,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.name, style: Theme.of(context).textTheme.subhead),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(text),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        // child:   CircleAvatar(child:   Text(this.name[0])),
        // child:   CircleAvatar(child: Image.network(_photoUrl)),
        child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                    image: NetworkImage(_photoUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
                boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)])),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}

class CustomToolTip extends StatelessWidget {
  String text;

  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Tooltip(preferBelow: false, message: "Copy", child: Text(text)),
      onTap: () {
        // print("Testing:~~~~~~~~~~~~~" + text);
        Clipboard.setData(ClipboardData(text: text));
        flutterTts.speak(text);
      },
    );
  }
}
