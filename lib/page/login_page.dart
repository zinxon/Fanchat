import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../app_holder.dart';
import '../style/theme.dart' as Theme;
import '../utils/bubble_indication_painter.dart';
import '../blocs/login_bloc_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  LoginBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    _bloc = LoginBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    _pageController?.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientStart,
                        Theme.Colors.loginGradientEnd
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Image(
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.fill,
                          image: AssetImage('assets/img/fanchat.png')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: _buildMenuBar(context),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 1) {
                            setState(() {
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 23.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: 300.0,
                      height: 200.0,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: StreamBuilder<String>(
                                stream: _bloc.email,
                                builder: (context, snapshot) {
                                  return TextField(
                                    focusNode: myFocusNodeEmailLogin,
                                    textInputAction: TextInputAction.next,
                                    onChanged: _bloc.changeEmail,
                                    onSubmitted: (term) {
                                      myFocusNodeEmailLogin.unfocus();
                                      FocusScope.of(context).requestFocus(
                                          myFocusNodePasswordLogin);
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.black,
                                        size: 22.0,
                                      ),
                                      hintText: "Email Address",
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 17.0),
                                    ),
                                  );
                                }),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextField(
                                focusNode: myFocusNodePasswordLogin,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (term) {
                                  myFocusNodePasswordLogin.unfocus();
                                },
                                onChanged: _bloc.changePassword,
                                obscureText: _obscureTextLogin,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    size: 22.0,
                                    color: Colors.black,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 17.0),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleLogin,
                                    child: Icon(
                                      FontAwesomeIcons.eye,
                                      size: 20.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 180.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Theme.Colors.loginGradientStart,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: Theme.Colors.loginGradientEnd,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: LinearGradient(
                          colors: [
                            Theme.Colors.loginGradientEnd,
                            Theme.Colors.loginGradientStart
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontFamily: "WorkSansBold"),
                          ),
                        ),
                        onPressed: _signInWithEmailAndPassword),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: "WorkSansMedium"),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.white10,
                              Colors.white,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      width: 100.0,
                      height: 1.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        "Or",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: "WorkSansMedium"),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white10,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      width: 100.0,
                      height: 1.0,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: _signInWithGoogle,
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          FontAwesomeIcons.google,
                          color: Color(0xFF0084ff),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: 200.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: StreamBuilder<String>(
                              stream: _bloc.email,
                              builder: (context, snapshot) {
                                return TextField(
                                  focusNode: myFocusNodeEmail,
                                  textInputAction: TextInputAction.next,
                                  onChanged: _bloc.changeEmail,
                                  onSubmitted: (term) {
                                    myFocusNodeEmail.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(myFocusNodePassword);
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      FontAwesomeIcons.envelope,
                                      color: Colors.black,
                                    ),
                                    hintText: "Email Address",
                                    hintStyle: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0),
                                  ),
                                );
                              }),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: StreamBuilder<String>(
                              stream: _bloc.password,
                              builder: (context, snapshot) {
                                return TextField(
                                  focusNode: myFocusNodePassword,
                                  textInputAction: TextInputAction.done,
                                  onChanged: _bloc.changePassword,
                                  onSubmitted: (term) {
                                    myFocusNodePassword.unfocus();
                                  },
                                  obscureText: _obscureTextSignup,
                                  style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.black,
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0),
                                    suffixIcon: GestureDetector(
                                      onTap: _toggleSignup,
                                      child: Icon(
                                        FontAwesomeIcons.eye,
                                        size: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 180.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Theme.Colors.loginGradientStart,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: Theme.Colors.loginGradientEnd,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: LinearGradient(
                          colors: [
                            Theme.Colors.loginGradientEnd,
                            Theme.Colors.loginGradientStart
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: _signUp,
                    )),
              ]),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _signInWithEmailAndPassword() {
    _bloc.signInWithEmailAndPassword();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AppHolder(
                  title: 'FacChat',
                )));
  }

  void _signUp() {
    _bloc.signUp().then((value) {
      if (value == 1) {
        Fluttertoast.showToast(
            msg: "Sign Up success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  void _signInWithGoogle() {
    _bloc.signInWithGoogle();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AppHolder(
                  title: 'FacChat',
                )));
  }
}
