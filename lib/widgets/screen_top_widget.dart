import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:initconsquiz/models/constants.dart';
import 'package:initconsquiz/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenTopWidget extends StatefulWidget {
  final int favoriteCount;
  final VoidCallback callback;
  final SharedPreferences prefs;
  final AudioPlayer audioPlayer;

  const ScreenTopWidget({
    super.key,
    required this.favoriteCount,
    required this.callback,
    required this.prefs,
    required this.audioPlayer,
  });

  @override
  State<ScreenTopWidget> createState() => _ScreenTopWidgetState();
}

class _ScreenTopWidgetState extends State<ScreenTopWidget> {
  void musicStateChange() async {
    if (widget.audioPlayer.state == PlayerState.playing) {
      await widget.audioPlayer.pause();
      widget.prefs.setBool(Constants.musicPlaying, false);
    } else {
      await widget.audioPlayer.resume();
      widget.prefs.setBool(Constants.musicPlaying, true);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 10),
                child: Icon(
                  Icons.favorite,
                  color: const Color(Constants.mainColor).withOpacity(0.7),
                ),
              ),
              Text(
                "${widget.favoriteCount}개",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: '하트받기',
                            detailInfo: '코인 10개를 받아요!',
                            callback: () {
                              widget.prefs.setInt(Constants.preferenceCount,
                                  widget.favoriteCount + 10);
                              widget.callback();
                              Navigator.pop(context);
                            },
                          ));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "하트받기",
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(Constants.mainColor).withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: musicStateChange,
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Icon(
                    widget.audioPlayer.state == PlayerState.playing
                        ? Icons.music_note_rounded
                        : Icons.music_off_rounded,
                    color: const Color(Constants.mainColor).withOpacity(0.7),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
