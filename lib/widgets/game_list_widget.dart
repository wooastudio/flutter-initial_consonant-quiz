import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:initconsquiz/models/constants.dart';
import 'package:initconsquiz/screens/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridViewItem extends StatelessWidget {
  final String subject;
  final List<dynamic> item;
  final VoidCallback callBack;
  final SharedPreferences prefs;
  final AudioPlayer audioPlayer;
  final QuizState quizState;

  const GridViewItem({
    super.key,
    required this.subject,
    required this.item,
    required this.callBack,
    required this.prefs,
    required this.audioPlayer,
    required this.quizState,
  });

  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GameScreen(
        subject: subject,
        items: item,
        prefs: prefs,
        audioPlayer: audioPlayer,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  List<Icon> createIcons(int count) {
    return List<Icon>.generate(
      count,
      (index) {
        return Icon(
          Icons.star,
          size: 20,
          color: const Color(Constants.mainColor).withOpacity(0.6),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String subjectTitle = subject.split('(')[0];
    String subjectExtra = subject.split('(')[1].split(')')[0];
    int rating = 1;
    if (subject.split('-').length > 1) {
      rating = int.parse(subject.split('-')[1]);
    }
    {
      return Builder(
        builder: (context) {
          if (quizState == QuizState.solved) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(createRoute()).then(
                  (value) {
                    callBack();
                  },
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color:
                            const Color(Constants.mainColor).withOpacity(0.6),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  subjectTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70.withOpacity(0.4),
                                  ),
                                ),
                                Text(
                                  "($subjectExtra)",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.scale(
                            scale: 2.2,
                            child: Transform.translate(
                              offset: const Offset(31, 20),
                              child: const ImageIcon(
                                size: 35,
                                AssetImage('assets/goodAnswer.png'),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (quizState == QuizState.unsolved) {
            return Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: createIcons(rating),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(createRoute()).then(
                  (value) {
                    callBack();
                  },
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color:
                            const Color(Constants.mainColor).withOpacity(0.6),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              subjectTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "($subjectExtra)",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
    }
  }
}
