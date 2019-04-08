import 'package:flutter/material.dart';
import 'page/chatbot_page.dart';
import 'page/user_page.dart';
import 'page/webview_page.dart';

class AppHolder extends StatefulWidget {
  AppHolder({Key key, this.title, this.indexGlobal = 0}) : super(key: key);

  final String title;
  int indexGlobal;

  @override
  _AppHolderState createState() => _AppHolderState();
}

class _AppHolderState extends State<AppHolder> {
  List<Widget> pageList = List();

  @override
  void initState() {
    super.initState();
    pageList
      ..add(WebViewPage(
        url: 'https://hk.finance.yahoo.com',
      ))
      ..add(UserPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: pageList[widget.indexGlobal],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatbotPage()),
          );
        },
        tooltip: 'Chatbot',
        child: Tab(icon: Image.asset("assets/img/fanchat.png")),
        isExtended: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  widget.indexGlobal = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  widget.indexGlobal = 1;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
