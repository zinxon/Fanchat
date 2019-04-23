import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';
import '../style/theme.dart' as Theme;

class YoutubePage extends StatefulWidget {
  @override
  _YoutubePageState createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  VideoPlayerController _videoController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Youtube影片",
          style: Theme.TextStyles.appBarTitle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        automaticallyImplyLeading: true,
      ),
      body: YoutubePlayer(
        context: context,
        source: "zEDJ7LBZO4M",
        quality: YoutubeQuality.HD,
        // callbackController is (optional).
        // use it to control player on your own.
        callbackController: (controller) {
          _videoController = controller;
        },
      ),
    );
  }
}
