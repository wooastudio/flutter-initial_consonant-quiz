import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:initconsquiz/models/constants.dart';
import 'package:initconsquiz/widgets/game_detail_widget.dart';
import 'package:initconsquiz/widgets/screen_top_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  final String subject;
  final List<dynamic> items;
  final SharedPreferences prefs;
  final AudioPlayer audioPlayer;

  const GameScreen({
    super.key,
    required this.subject,
    required this.items,
    required this.prefs,
    required this.audioPlayer,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 93),
            child: const Text(
              "초성퀴즈",
              style: TextStyle(fontWeight: FontWeight.w900),
            )),
        backgroundColor: Colors.grey.shade100,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScreenTopWidget(
            favoriteCount: widget.prefs.getInt(Constants.preferenceCount) ?? 50,
            callback: () {
              setState(() {});
            },
            prefs: widget.prefs,
            audioPlayer: widget.audioPlayer,
          ),
          const SizedBox(
            height: 20,
          ),
          GameDetailWidget(
            subject: widget.subject,
            items: widget.items,
            callback: () {
              setState(() {});
            },
            prefs: widget.prefs,
          )
        ],
      ),
    );
  }
}
