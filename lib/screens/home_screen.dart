import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:initconsquiz/models/constants.dart';
import 'package:initconsquiz/models/data_services.dart';
import 'package:initconsquiz/widgets/screen_top_widget.dart';
import 'package:initconsquiz/widgets/game_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final SharedPreferences prefs;
  bool isFirstLaunch = false;

  HomeScreen({
    super.key,
    required this.prefs,
    required this.isFirstLaunch,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<Map<dynamic, dynamic>> dataList = DataServices.getAllData();

  late final AppLifecycleListener listener;
  late AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await audioPlayer.setSource(AssetSource(
          'Happy & Funny Cartoon Loop - Royalty free Music - Video Game Background Music.mp3'));
      //await player.resume();
      setState(() {});
    });

    listener = AppLifecycleListener(
      onStateChange: handleStateChange,
    );
  }

  Future<void> handleStateChange(AppLifecycleState state) async {
    log('state: $state');

    if (state == AppLifecycleState.paused) {
      await audioPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (widget.prefs.getBool(Constants.musicPlaying) == null) {
        await audioPlayer.resume();
      } else {
        if (widget.prefs.getBool(Constants.musicPlaying)! == true) {
          await audioPlayer.resume();
        }
      }
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void showAlert() {
    bool isChecked = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "반갑습니다:)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '다양한 초성퀴즈가 준비되어 있어요!\n 재미있게 즐겨주세요:D\n\n 힌트를 보거나 오답 제출 시에는\n 하트가 1개 차감되니 참고해서 즐겨주세요!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.prefs
                                .setBool(Constants.firstDialogShow, isChecked);
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(Constants.mainColor)
                                  .withOpacity(0.5),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          child: const Text(
                            '확인',
                            style: TextStyle(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          const Text("다시 보지 않기"),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    ).then(
      (value) {
        widget.isFirstLaunch = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        // music play when starts
        if (widget.prefs.getBool(Constants.musicPlaying) == null) {
          audioPlayer.resume();
        }

        if (widget.isFirstLaunch == true) {
          if (widget.prefs.getBool(Constants.firstDialogShow) != null &&
              widget.prefs.getBool(Constants.firstDialogShow) == false) {
            showAlert();
          }
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "초성퀴즈",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        backgroundColor: Colors.grey.shade100,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScreenTopWidget(
            favoriteCount: widget.prefs.getInt(Constants.preferenceCount) ?? 30,
            callback: () {
              setState(() {});
            },
            prefs: widget.prefs,
            audioPlayer: audioPlayer,
          ),
          FutureBuilder(
            future: dataList,
            builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
              if (snapshot.data != null) {
                Map<dynamic, dynamic> myMap = Map.from(snapshot.requireData);
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: const BoxDecoration(),
                    child: makeList(myMap),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  GridView makeList(Map<dynamic, dynamic> myMap) {
    bool isCurrent = false;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // number of items in each row
        mainAxisSpacing: 10, // spacing between rows
        crossAxisSpacing: 10, // spacing between columns
        mainAxisExtent: 100,
      ),
      itemCount: myMap.length,
      //padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        String subject = myMap.keys.elementAt(index);
        QuizState quizState = QuizState.unsolved;

        if (isCurrent == true) {
          widget.prefs.setInt(subject, QuizState.currentQuiz.index);
          isCurrent = false;
        }

        if (index == 0 && widget.prefs.getInt(subject) == null) {
          quizState = QuizState.currentQuiz;
        } else if (widget.prefs.getInt(subject) != null) {
          quizState = QuizState.values[widget.prefs.getInt(subject)!];
          if (quizState == QuizState.solving) {
            isCurrent = true;
            widget.prefs.setInt(subject, QuizState.solved.index);
            quizState = QuizState.solved;
          }
        }

        return GridViewItem(
          subject: subject,
          item: myMap[subject],
          prefs: widget.prefs,
          callBack: () {
            setState(() {});
          },
          audioPlayer: audioPlayer,
          quizState: quizState,
        );
      },
    );
  }
}
