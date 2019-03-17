import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class HomePage extends StatefulWidget {
  HomePage();

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  TextEditingController controller = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  var urlString = "https://hk.finance.yahoo.com";

  launchUrl() {
    setState(() {
      urlString = controller.text;
      flutterWebviewPlugin.reloadUrl(urlString);
      // flutterWebviewPlugin.resize(
      //     Rect.fromLTWH(0.0, 0.0, MediaQuery.of(context).size.width, 300.0));
      // // flutterWebViewPlugin.launch(
      // //   urlString,
      // //   rect: Rect.fromLTWH(0.0, 0.0, MediaQuery.of(context).size.width, 300.0),
      // // );
    });
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      print(wvs.type);
    });
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop(100);

    ///彈出頁面并傳回int值100，用于上一個界面的回調
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: WebviewScaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: TextField(
              autofocus: false,
              controller: controller,
              textInputAction: TextInputAction.go,
              onSubmitted: (url) => launchUrl(),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Url Here",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () => launchUrl(),
              )
            ],
          ),
          initialChild: Center(
            child: CircularProgressIndicator(),
          ),
          url: urlString,
          withZoom: true,
          enableAppScheme: true
          // hidden: false,
          ),
    );
  }
}
