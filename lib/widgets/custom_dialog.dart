import 'package:flutter/material.dart';
import 'package:initconsquiz/models/constants.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String detailInfo;
  final VoidCallback callback;

  const CustomDialog({
    super.key,
    required this.title,
    required this.detailInfo,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              detailInfo,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      callback();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor:
                            const Color(Constants.mainColor).withOpacity(0.5),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    child: const Text(
                      '확인',
                      style: TextStyle(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
