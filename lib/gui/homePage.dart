// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../utils/Worker.dart';
import '../utils/Root.dart';
import 'package:just_toast/just_toast.dart';

// ignore: camel_case_types
class buildHomePage extends StatelessWidget {
  const buildHomePage({super.key});

  static String status = '';
  static String pid = '';
  static String pkg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Choose your game to optimize',
                style: TextStyle(color: Color.fromARGB(255, 215, 215, 215))),
            buildGameButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildGameButtons(BuildContext context) {
    List<String> gameNames = [
      Worker.PUBG_MOBILE,
    ];

    return Column(
      children: gameNames.map((String gameName) {
        return TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed) ||
                    states.contains(MaterialState.focused)) {
                  return const Color.fromARGB(255, 85, 130, 255);
                }
                return const Color.fromARGB(255, 255, 255, 255);
              },
            ),
          ),
          onPressed: () {
            int ret = Worker.optimizer(gameName);

            pid = Worker.process_ID;
            pkg = Worker.pkg;
            if (ret == RootCheck.ROOT_DENIED) {
              status = 'Root Denied';
            } else if (ret == Worker.ERROR) {
              if (pid == '') {
                status = 'Error for package $pkg';
              } else {
                status = 'Error for pid $pid';
              }
            } else if (ret == 1) {
              status = 'First open the game';
            } else {
              status = 'Done';
            }
            showToast(context: context, text: status);
          },
          child: Text(gameName,
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        );
      }).toList(),
    );
  }
}
