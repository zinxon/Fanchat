import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:fluro/fluro.dart';

import 'page/login_page.dart';
import 'blocs/login_bloc_provider.dart';
import 'blocs/user_bloc_provider.dart';
import 'route/routes.dart';

void main() {
  final router = new Router();
  Routes.configureRoutes(router);
  runApp(LoginBlocProvider(
    child: UserBlocProvider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FanChat',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            // platform: TargetPlatform.iOS,
          ),
          home: MyApp(),
          onGenerateRoute: Routes.router.generator),
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
        image: Image.asset('assets/img/fanchat.png'),
        backgroundColor: Colors.orange,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 35.0,
        loaderColor: Colors.white);
  }
}
