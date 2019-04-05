import 'package:flutter/material.dart';
import 'page/chatbot_page.dart';
import 'page/user_page.dart';
import 'page/home_page.dart';
import 'page/webview_page.dart';
// import 'package:flutter/services.dart';

class AppHolder extends StatefulWidget {
  AppHolder({Key key, this.title, this.indexGlobal}) : super(key: key);

  final String title;
  int indexGlobal = 0;

  @override
  _AppHolderState createState() => _AppHolderState();
}

class _AppHolderState extends State<AppHolder> {
  List<Widget> pageList = List();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    pageList..add(WebViewPage())..add(UserPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: pageList[_index],
          // height: _index == 0
          //     ? MediaQuery.of(context).size.height * 0.85
          //     : MediaQuery.of(context).size.height,
        ),
        // bottom: true,
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
                  _index = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _index = 1;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
