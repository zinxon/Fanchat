import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page/chatbot_page.dart';
import 'page/user_page.dart';
import 'page/home_page.dart';

class AppHolder extends StatefulWidget {
  AppHolder({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AppHolderState createState() => new _AppHolderState();
}

class _AppHolderState extends State<AppHolder> {
  List<Widget> _eachView;
  List<Widget> pageList = List();
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    pageList..add(HomePage())..add(UserPage("User"));
    // _eachView = List();
    // _eachView..add(EachView('Home'))..add(EachView('User'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: pageList[_index],
          // height: _index == 0 ? 720 : MediaQuery.of(context).size.height,
          height: _index == 0
              ? MediaQuery.of(context).size.height * 0.85
              : MediaQuery.of(context).size.height,
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
        child: Tab(icon: new Image.asset("assets/img/fanchat.png")),
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
