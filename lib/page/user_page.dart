import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_holder.dart';

SharedPreferences preferences;
String _username;
String _photoUrl;

class UserPage extends StatefulWidget {
  String _title;

  UserPage(this._title);

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

  // @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _requestPop,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text(widget._title),
//           centerTitle: true,
//         ),
//         body: Center(child: Text(widget._title)),
//       ),
//     );
//   }
// }
  void _getUserInfo() async {
    preferences = await SharedPreferences.getInstance();
    String uid = preferences.getString("id");
    final QuerySnapshot result = await Firestore.instance
        .collection("users")
        .where("id", isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    _username = documents[0]['username'];
    _photoUrl = documents[0]['profilePicture'];
    print("photoUrl:" + _photoUrl);
    print(documents[0]['username']);
  }

  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          body: new Stack(
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
                              // 'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'
                              image: NetworkImage(_photoUrl),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 7.0, color: Colors.orange)
                          ])),
                  SizedBox(height: 90.0),
                  Text(
                    // 'Tom Cruise',
                    _username,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Subscribe guys',
                    style: TextStyle(
                        fontSize: 17.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: 95.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'Edit Name',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: 95.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.redAccent,
                        color: Colors.red,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ))
                ],
              ))
        ],
      )),
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

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
