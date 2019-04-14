import 'package:fluro/fluro.dart';

import '../page/chatbot_page.dart';
import '../page/login_page.dart';
import '../page/quiz_page.dart';
import '../page/user_page.dart';
import '../page/webview_page.dart';

class Routes {
  static Router router;
  static String chatbotPage = '/chatbotPage';
  static String loginPage = '/loginPage';
  static String quizPage = '/quizPage';
  static String userPage = '/userPage';
  static String webviewPage = '/webviewPage';

  static void configureRoutes(Router router) {
    router.define(chatbotPage,
        handler: Handler(handlerFunc: (context, params) => ChatbotPage()));
    router.define(loginPage,
        handler: Handler(handlerFunc: (context, params) => LoginPage()));
    router.define(quizPage,
        handler: Handler(handlerFunc: (context, params) => QuizPage()));
    router.define(userPage,
        handler: Handler(
            handlerFunc: (context, params) =>
                UserPage())); // router.define(loginPage, handler: Handler(handlerFunc: (context, params) {
    router.define(webviewPage,
        handler: Handler(
            handlerFunc: (context, params) =>
                WebViewPage())); //   var message = params['message']?.first; //取出傳參
    Routes.router = router;
  }

  // var userHandler =
  //     Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  //   return UsersScreen(params["id"][0]);
  // });

  // void defineRoutes(Router router) {
  //   router.define("/users/:id", handler: usersHandler);

  // it is also possible to define the route transition to use
  // router.define("users/:id", handler: usersHandler, transitionType: TransitionType.inFromLeft);

}
