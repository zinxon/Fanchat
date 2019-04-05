import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_holder.dart';
import '../models/user_model.dart';
import 'login_page.dart';
import 'result_page.dart';
import 'webviewquiz_page.dart';

// Future<FirebaseUser> _firebaseUser = FirebaseAuth.instance.currentUser();
UserModel _userModel = UserModel.instance;

SharedPreferences preferences;

// String _username = "User";
// String _photoUrl =
// 'https://firebasestorage.googleapis.com/v0/b/fanchat.appspot.com/o/business_avatar_man_businessman_profile_account_contact_person-512.png?alt=media&token=b9ed1227-9993-4be2-a1ae-2c4f3846e489';

class UserPage extends StatefulWidget {
  UserPage();

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<bool> _requestPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AppHolder(
                  title: 'FacChat',
                )));
    return Future.value(false);
  }

  // Future<Null> _function() async {
  //   // /**
  //   // This Function will be called every single time
  //   // when application is opened and it will check
  //   // if the value inside Shared Preference exist or not
  //   // **/
  //   SharedPreferences prefs;
  //   prefs = await SharedPreferences.getInstance();
  //   this.setState(() {
  //     if (prefs.getString("username") != null) {
  //       loggedIn = true;
  //     } else {
  //       loggedIn = false;
  //     }
  //   });
  // }

  // Future<Null> _getUserInfo() async {

  //   final FirebaseUser user = await _auth.currentUser();
  //   final userid = user.uid;
  //   // preferences = await SharedPreferences.getInstance();
  //   // String uid = preferences.getString("id");
  //   final QuerySnapshot result = await Firestore.instance
  //       .collection("users")
  //       .where("id", isEqualTo: userid)
  //       .getDocuments();
  //   final List<DocumentSnapshot> documents = result.documents;
  //   _username = documents[0]['username'];
  //   _photoUrl = documents[0]['photoUrl'];
  //   print("uid:" + userid);
  //   print("username:" + _username);
  //   // _username = preferences.getString("username");
  //   // _photoUrl = preferences.getString("photoUrl");
  // }

  void initState() {
    super.initState();
    // _firebaseUser.then((user) {
    //   setState(() {
    //     _photoUrl = user.photoUrl;
    //     _username = user.displayName;
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
    // _getUserInfo();
    // _firebaseUser = FirebaseAuth.instance.currentUser();
    // FirebaseAuth.instance.currentUser().then((user) {
    //   setState(() {
    //     _photoUrl = user.photoUrl;
    //     _username = user.displayName;
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
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
                              image: NetworkImage(_userModel.profilePicture),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 7.0, color: Colors.black)
                          ])),
                  SizedBox(height: 25.0),
                  Text(
                    _userModel.username,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    _userModel.didQuiz
                        ? _userModel.investorType
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
                        width: MediaQuery.of(context).size.height * 0.85,
                        child: Column(children: <Widget>[
                          Flexible(
                              child: ListView.builder(
                            padding: EdgeInsets.all(8.0),
                            // reverse: true,
                            itemCount: _userModel.stockCodeList.length,
                            // itemBuilder: (_, int index) =>
                            //     Text(_userModel.stockCodeList[index]),
                            itemBuilder: (_, int index) {
                              return Dismissible(
                                key: Key(_userModel.stockCodeList[index]),
                                background: _myHiddenContainer() ?? Container(),
                                child: _myListContainer(
                                        _userModel.stockList[index].stockName,
                                        _userModel
                                            .stockList[index].stockCode) ??
                                    Container(),
                                // onDismissed: (direction) {
                                //   if (direction ==
                                //       DismissDirection.startToEnd) {
                                //     Fluttertoast.showToast(msg: "Delete");
                                //     if (_userModel.stockList.contains(
                                //         _userModel.stockList.removeAt(index))) {
                                //       setState(() {
                                //         _userModel.stockList.remove(_userModel
                                //             .stockList
                                //             .removeAt(index));
                                //       });
                                //     }
                                //   } else {
                                //     if (direction ==
                                //         DismissDirection.endToStart) {
                                //       Fluttertoast.showToast(msg: "Archive");
                                //       // Archive functionality
                                //     }
                                //   }
                                // },
                              );
                            },
                          )),
                          Divider(height: 1.0),
                        ]),
                      )),
                      // SizedBox(height: 25.0),
                      Container(
                          margin: const EdgeInsets.only(top: 290, left: 20.0),
                          height: 30.0,
                          width: 95.0,
                          child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7.0,
                              child: _userModel.didQuiz
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ResultPage(
                                                    url: _userModel.resultUrl,
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
                                              builder: (context) => QuizPage()),
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
                      // SizedBox(
                      //   height: 300,
                      // ),
                      Container(
                          margin: const EdgeInsets.only(top: 290, left: 230.0),
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
      )),
    );
  }

  Widget _myListContainer(String taskname, String subtask) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120.0,
        child: Material(
          color: Colors.white,
          elevation: 14.0,
          shadowColor: Color(0x802196F3),
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: 10.0,
                  color: Colors.orange,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(taskname,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(subtask,
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.blueAccent)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                // child: Container(
                //   child: Text(taskTime,
                //       style:
                //           TextStyle(fontSize: 18.0, color: Colors.black45)),
                // ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myHiddenContainer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.orange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                icon: Icon(FontAwesomeIcons.solidTrashAlt),
                color: Colors.white,
                onPressed: () {
                  setState(() {});
                }),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(FontAwesomeIcons.archive),
                color: Colors.white,
                onPressed: () {
                  setState(() {});
                }),
          ),
        ],
      ),
    );
  }

  void didQuiz() {
    if (_userModel.didQuiz) {}
  }

  Future<void> _handleSignOut() async {
    googleSignIn.disconnect();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<Null> logoutUser() async {
    //logout user
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await googleSignIn.signOut();
    prefs.clear();
    prefs.commit();
    //   this.setState(() {
    //     /*
    //    updating the value of loggedIn to false so it will
    //    automatically trigger the screen to display loginScaffold.
    // */
    //     loggedIn = false;
    //   });
    prefs.setBool("isLogged", false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<Null> _logout() async {
    FirebaseAuth.instance.signOut().then((val) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      Fluttertoast.showToast(msg: "Logout successful");
    }).catchError((e) {
      print(e);
    });
  }
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
