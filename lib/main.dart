import 'package:flutter/material.dart';
import 'Worker.dart';
//import 'dart:io';
//import 'package:root/root.dart';
//import 'package:toast/toast.dart';
//import 'dart:developer';
//import 'AppLog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rave Tweaker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tweaker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: non_constant_identifier_names
  String exitCode_res = '0';
  String pid = '';
  String pkg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Exit status: $exitCode_res for pid $pid with pkg $pkg',
            ),
            const Text(
              'Chose your game to optimze',
            ),
            /**
             * Button for PUBG Mobile.
             */
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused)) return Colors.red;
                  return null; // Defer to the widget's default.
                }),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.focused)) return null;
                  return const Color.fromARGB(165, 212, 236, 255);
                }),
              ),
              // this button work only for pubg mobile
              onPressed: () {
                int ret = Worker.optimizer(Worker.PUBG_MOBILE);
                setState(() {
                  exitCode_res = ret.toString();
                  pid = Worker.process_ID;
                  pkg = Worker.pkg;
                });
              },
              child: const Text('PUBG Mobile'),
            )
          ],
        ),
      ),
    );
  }
}
