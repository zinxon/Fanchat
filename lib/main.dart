import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';

import 'page/login_page.dart';
import 'blocs/login_bloc_provider.dart';
// import 'app_holder.dart';
// import 'style/theme.dart' show AppColors;

void main() {
  runApp(LoginBlocProvider(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FanChat',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // platform: TargetPlatform.iOS,
      ),
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.orange, //or set color with: Color(0xFF0000FF)
    ));
    return SplashScreen(
        seconds: 1,
        navigateAfterSeconds: LoginPage(),
        // title: Text(
        //   'FanChat',
        //   style:   TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 20.0,
        //       // color: Color(AppColors.AppBarColor)),
        //       color: Colors.white),
        // ),
        image: Image.asset('assets/img/fanchat.png'),
        backgroundColor: Colors.orange,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 35.0,
        // onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.white);
  }
}
