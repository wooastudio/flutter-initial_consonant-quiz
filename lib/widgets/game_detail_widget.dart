import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:initconsquiz/models/constants.dart';
import 'package:initconsquiz/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameDetailWidget extends StatefulWidget {
  final String subject;
  final List<dynamic> items;
  final VoidCallback callback;
  final SharedPreferences prefs;

  const GameDetailWidget({
    super.key,
    required this.subject,
    required this.items,
    required this.callback,
    required this.prefs,
  });

  @override
  State<GameDetailWidget> createState() => _GameDetailWidgetState();
}

class _GameDetailWidgetState extends State<GameDetailWidget> {
  final myTextController = TextEditingController();

  String initWord = "";
  String hintText = "힌트: ";
  int currentCount = 1;
  int hintCount = 0;
  int currentPos = 0;
  bool isCheckAnswer = false;
  bool isCorrect = false;
  late Timer timer;
  Random random = Random();
  Map<int, bool> checkState = {};

  @override
  void initState() {
    super.initState();

    currentPos = random.nextInt(widget.items.length);
    checkState[currentPos] = true;
    initWord = widget.items[currentPos]["initial"];
  }

  void checkAnswer(String inputWord) {
    if (currentCount == widget.items.length) {
      isCheckAnswer = true;
      isCorrect = true;
      currentCount = -1;
      bool isSolved = false;
      if (widget.prefs.getInt(widget.subject) != null) {
        QuizState state =
            QuizState.values[widget.prefs.getInt(widget.subject)!];
        if (state == QuizState.solved) {
          isSolved = true;
        }
      }
      if (isSolved == false) {
        widget.prefs.setInt(widget.subject, QuizState.solving.index);
      }
    } else {
      isCheckAnswer = true;
      if (inputWord == widget.items[currentPos]["name"]) {
        currentCount++;

        while (true) {
          currentPos = random.nextInt(widget.items.length);
          if (checkState.containsKey(currentPos) == false) {
            checkState[currentPos] = true;
            break;
          }
        }
        initWord = widget.items[currentPos]["initial"];
        isCorrect = true;
        hintCount = 0;
        hintText = "힌트: ";
      }
      //else {
      //   widget.prefs.setInt(Constants.preferenceCount,
      //       widget.prefs.getInt(Constants.preferenceCount)! - 1);
      // }
    }

    //onTimerStarted();
    Timer(const Duration(seconds: 1), () {
      isCheckAnswer = false;
      isCorrect = false;
      setState(() {
        if (currentCount == -1) {
          Navigator.pop(context);
        }
      });
    });
    setState(() {});
  }

  // void onTick(Timer timer) {
  //   timer.cancel();
  //   isCheckAnswer = false;
  //   isCorrect = false;
  //   setState(() {});
  // }

  // void onTimerStarted() {
  //   timer = Timer.periodic(
  //     const Duration(seconds: 1),
  //     onTick,
  //   );
  // }

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }

  void onHintShowTap() async {
    if (hintCount < 2) {
      hintCount++;
      if (hintCount == 2) {
        hintText = "$hintText, ${widget.items[currentPos]["shint"]}";
      } else {
        hintText = hintText + widget.items[currentPos]["fhint"];
      }
      setState(() {});

      widget.prefs.setInt(Constants.preferenceCount,
          widget.prefs.getInt(Constants.preferenceCount)! - 1);

      widget.callback();
    }
  }

  void onAnswerShowTap() {
    if (widget.prefs.getInt(Constants.preferenceCount)! < 5) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: '하트가 필요해요!',
            detailInfo: '정답을 보기 위해서 하트를 받아주세요!',
            callback: () {
              Navigator.pop(context);
            },
          );
        },
      );
    } else {
      initWord = widget.items[currentPos]["name"];
      widget.prefs.setInt(Constants.preferenceCount,
          widget.prefs.getInt(Constants.preferenceCount)! - 5);

      setState(() {});
      widget.callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 280,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: const BoxDecoration(),
                      child: Text(
                        "${currentCount.toString()} / ${widget.items.length.toString()}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 150,
                      decoration: const BoxDecoration(),
                      child: Text(
                        "${widget.subject.split('(')[0]}\n(${widget.subject.split('(')[1].split(')')[0]})",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Builder(
                          builder: (context) {
                            int count =
                                widget.prefs.getInt(Constants.preferenceCount)!;
                            if (count > 0) {
                              return GestureDetector(
                                onTap: () {
                                  onHintShowTap();
                                },
                                child: Container(
                                  width: 50,
                                  decoration: const BoxDecoration(),
                                  child: Text(
                                    "힌트\n보기",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: hintCount < 2
                                          ? Colors.grey
                                          : Colors.grey.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                width: 50,
                                decoration: const BoxDecoration(),
                                child: Text(
                                  "힌트\n보기",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Builder(builder: (context) {
                          if (initWord != widget.items[currentPos]["name"]) {
                            return GestureDetector(
                              onTap: () {
                                onAnswerShowTap();
                              },
                              child: Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: const BoxDecoration(),
                                child: const Text(
                                  "정답\n보기",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              width: 50,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(),
                              child: Text(
                                "정답\n보기",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  initWord,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(hintText),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextFormField(
                          onFieldSubmitted: (value) {
                            checkAnswer(myTextController.text);
                            myTextController.clear();
                          },
                          controller: myTextController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "여기에 답을 입력하세요",
                            hintStyle: TextStyle(
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        checkAnswer(myTextController.text);
                        myTextController.clear();
                      },
                      child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: const Color(Constants.mainColor)
                                .withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Align(
                            child: Text(
                              "정답확인",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: isCheckAnswer ? true : false,
            child: isCorrect
                ? const ImageIcon(
                    size: 200,
                    AssetImage('assets/goodAnswer.png'),
                    color: Colors.green,
                  )
                : Icon(
                    size: 200,
                    Icons.cancel_rounded,
                    color: Colors.red.withOpacity(0.7),
                  ),
          ),
        ],
      ),
    );
  }
}
