import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/user_bloc_provider.dart';
import '../app_holder.dart';
import '../models/user_model.dart';
import '../models/stock_model.dart';
import '../widgets/card_widget.dart';
import '../widgets/list_widget.dart';
import 'webview_page.dart';
import 'login_page.dart';
import 'quiz_page.dart';

SharedPreferences prefs;

class UserPage extends StatefulWidget {
  UserPage();

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserBloc _userBloc;

  Future<bool> _requestPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AppHolder()));
    return Future.value(false);
  }

  @override
  void didChangeDependencies() {
    _userBloc = UserBlocProvider.of(context);
    _userBloc.updateStockDataList();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: StreamBuilder<UserModel>(
          stream: _userBloc.userModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                  body: Stack(
                children: <Widget>[
                  ClipPath(
                    child: Container(color: Colors.orange),
                    clipper: getClipper(),
                  ),
                  Positioned(
                      width: 350.0,
                      left: 30,
                      top: MediaQuery.of(context).size.height / 5,
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data.profilePicture),
                                      fit: BoxFit.cover),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(75.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 7.0, color: Colors.black)
                                  ])),
                          SizedBox(height: 25.0),
                          Text(
                            snapshot.data.username,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            snapshot.data.didQuiz
                                ? snapshot.data.investorType
                                : '點擊下方Quiz按鈕進行MBTI測驗',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Montserrat'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: <Widget>[
                              Scrollbar(
                                  child: Container(
                                height: 280,
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Column(children: <Widget>[
                                  Flexible(
                                      child: ListView.builder(
                                    padding: EdgeInsets.all(8.0),
                                    itemCount: snapshot.data.stockList.length,
                                    itemBuilder: (_, int index) {
                                      return Dismissible(
                                        // onResize: () async {
                                        //   _userBloc.getStockData(snapshot
                                        //       .data.stockList[index].stockCode);
                                        // },
                                        key: Key(snapshot
                                            .data.stockList[index].stockCode),
                                        background:
                                            myHiddenContainer(context) ??
                                                Container(),
                                        child: InkWell(
                                            highlightColor: Colors.orange,
                                            onTap: () {
                                              print('index: $index');
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      _dialogBuilder(
                                                          context,
                                                          snapshot.data
                                                                  .stockList[
                                                              index]));
                                            },
                                            // child: myListContainer(
                                            //         snapshot
                                            //             .data
                                            //             .stockList[index]
                                            //             .stockName,
                                            //         snapshot
                                            //             .data
                                            //             .stockList[index]
                                            //             .stockCode,
                                            //         snapshot
                                            //             .data
                                            //             .stockList[index]
                                            //             .stockData
                                            //             .stockData) ??
                                            //     Container()),
                                            child: isLoading(snapshot.data
                                                    .stockList[index].stockData)
                                                ? myListContainer(
                                                    snapshot
                                                        .data
                                                        .stockList[index]
                                                        .stockName,
                                                    snapshot
                                                        .data
                                                        .stockList[index]
                                                        .stockCode,
                                                    snapshot
                                                        .data
                                                        .stockList[index]
                                                        .stockData
                                                        .stockData)
                                                : CircularProgressIndicator()),
                                        onDismissed: (direction) {
                                          _userBloc.delStock(
                                              snapshot.data, index);
                                          setState(() {});
                                        },
                                      );
                                    },
                                  )),
                                  Divider(height: 1.0),
                                ]),
                              )),
                              // SizedBox(height: 25.0),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 290, left: 20.0),
                                  height: 30.0,
                                  width: 95.0,
                                  child: Material(
                                      borderRadius: BorderRadius.circular(20.0),
                                      shadowColor: Colors.greenAccent,
                                      color: Colors.green,
                                      elevation: 7.0,
                                      child: snapshot.data.didQuiz
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebViewPage(
                                                            isBack: true,
                                                            title: 'Result',
                                                            url: snapshot
                                                                .data.resultUrl,
                                                          )),
                                                );
                                              },
                                              child: Center(
                                                child: Text(
                                                  'Result',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QuizPage()),
                                                );
                                              },
                                              child: Center(
                                                child: Text(
                                                  'Quiz',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                            ))),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 290, left: 230.0),
                                  height: 30.0,
                                  width: 95.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.redAccent,
                                    color: Colors.red,
                                    elevation: 7.0,
                                    child: GestureDetector(
                                      onTap: _logout,
                                      child: Center(
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ))
                ],
              ));
            } else if (snapshot.hasError) {
              return Center(
                // child: CircularProgressIndicator(),
                child: Text("${snapshot.error}"),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _dialogBuilder(BuildContext context, Stock stock) {
    return SimpleDialog(
      backgroundColor: Colors.transparent,
      children: <Widget>[Center(child: cardWidget(context, stock, false))],
    );
  }

  Future<Null> _logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    FirebaseAuth.instance.signOut().then((val) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      Fluttertoast.showToast(msg: "Logout successful");
    }).catchError((e) {
      print(e);
    });
  }
}

bool isLoading(var stockData) {
  if (stockData != null) {
    return true;
  }
  return false;
  // isLoading(stockData);
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
