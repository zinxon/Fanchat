import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app_holder.dart';
import '../style/theme.dart' show AppColors, TextStyles;
import '../models/user_model.dart';
import '../models/stock_model.dart';
import '../widgets/card_widget.dart';
import '../blocs/user_bloc_provider.dart';
import 'webview_page.dart';

UserModel _userModel = UserModel.instance;
UserBloc _userBloc;

class ChatbotPage extends StatefulWidget {
  ChatbotPage({Key key}) : super(key: key);

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
  void didChangeDependencies() {
    _userBloc = UserBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  initState() {
    super.initState();
    initTts();
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
                decoration: InputDecoration(
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
    bool isGetInfo = false;
    Stock stock;
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/config/dialogflow.json").build();
    Dialogflow dialogflow = Dialogflow(
        authGoogle: authGoogle, language: Language.CHINESE_CANTONESE);
    AIResponse response = await dialogflow.detectIntent(query);
    if (response.queryResult.action == "get_stock_information") {
      var temp = await Firestore.instance
          .collection("stockCode")
          .where("stockCode", isEqualTo: response.getMessage())
          .getDocuments();
      var tempData = temp.documents[0].data;
      print(tempData);
      stock = Stock.fromFirebase(tempData);
      // print(stock.website);
      isGetInfo = true;
    }
    ChatMessage message = ChatMessage(
        text: response.getMessage(),
        // text: response.getListMessage()[0],
        // text: CardDialogflow(response.getListMessage()[0]['text']['text']).title,
        name: "FanChat",
        type: false,
        isGetInfo: isGetInfo,
        stock: stock);
    if (response.queryResult.action == "add_stock") {
      print("action: " + response.queryResult.action);
      addStock(response);
    }
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      name: _userModel.username,
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _response(text);
  }

  Future<bool> _requestPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AppHolder()));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "FanChat",
              style: TextStyles.appBarTitle,
            ),
            automaticallyImplyLeading: true,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppHolder()));
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
      try {
        if (_userModel != null) {
          _userBloc.addStock(stockCode);
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
  ChatMessage(
      {this.text, this.name, this.type, this.isGetInfo = false, this.stock});

  final String text;
  final String name;
  final bool isGetInfo;
  final bool type;
  final Stock stock;

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
            isGetInfo
                ? cardWidget(context, stock, true)
                : Container(
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
            Text(this.name, style: TextStyle(fontWeight: FontWeight.bold)),
            // style: Theme.of(context).textTheme.subhead),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              // child: Text(text),
              child: Container(
                child: Text(
                  text,
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: BoxDecoration(
                    color: AppColors.greyColor2,
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                    image: NetworkImage(_userModel.profilePicture),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
                boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)])),
      )
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
  String textUrl;

  CustomToolTip({this.text});

  bool checkUrl() {
    if (text.contains("https")) {
      textUrl = text.split(" ")[0];
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Tooltip(
        preferBelow: false,
        message: "Go",
        // child: Text(text),
        child: Container(
          width: 270,
          child: Text.rich(checkUrl()
              ? TextSpan(
                  children: [
                    TextSpan(
                        text: text.split(' ')[0],
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        )),
                    TextSpan(text: text.split(' ')[1])
                  ],
                )
              : TextSpan(text: text)),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          decoration: BoxDecoration(
              color: AppColors.greyColor2,
              borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
      onTap: () {
        if (checkUrl()) {
          // Clipboard.setData(ClipboardData(text: text));
          Fluttertoast.showToast(
              msg: "GO",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 14.0);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(
                      url: textUrl,
                      isBack: true,
                      title: "股票預測圖表",
                    )),
          );
        }
      },
    );
  }
}
