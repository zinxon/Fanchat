import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../app_holder.dart';

class ChatbotPage extends StatefulWidget {
  ChatbotPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatbotPage createState() => new _ChatbotPage();
}

FlutterTts flutterTts;
String language;
String voice;

class _ChatbotPage extends State<ChatbotPage>
    with AutomaticKeepAliveClientMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  @override
  bool get wantKeepAlive => true;

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
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                autofocus: true,
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    // new InputDecoration.collapsed(hintText: "Send a message",),
                    InputDecoration(
                        hintText: "Send a message",
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
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
    ChatMessage message = new ChatMessage(
      text: response.getMessage() ??
          new CardDialogflow(response.getListMessage()[0]).title,
      name: "FanChat",
      type: false,
    );
    print(response.getListMessage());
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "James",
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
          appBar: new AppBar(
            title: new Text("FanChat"),
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
                  child: new Column(children: <Widget>[
            new Flexible(
                child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            )
          ])))),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0, top: 10),
        child:
            new CircleAvatar(child: new Image.asset("assets/img/fanchat.png")),
      ),
      new Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 20,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Text(this.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      // margin: const EdgeInsets.only(top: 5),
                      child: IconButton(
                        icon: Icon(Icons.volume_up),
                        color: Colors.black,
                        onPressed: () {
                          flutterTts.speak(text);
                        },
                      ),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
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
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(child: new Text(this.name[0])),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
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
    return new GestureDetector(
      child:
          new Tooltip(preferBelow: false, message: "Copy", child: Text(text)),
      onTap: () {
        // print("Testing:~~~~~~~~~~~~~" + text);
        Clipboard.setData(new ClipboardData(text: text));
        flutterTts.speak(text);
      },
    );
  }
}
