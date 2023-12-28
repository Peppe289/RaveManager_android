import 'package:flutter/material.dart';
import 'Worker.dart';
import 'Root.dart';
import 'package:just_toast/just_toast.dart';
import 'RamManage.dart';
import 'drawer.dart';
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
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
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
  String status = '';
  String pid = '';
  String pkg = '';
  String freeram = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title,
            style: const TextStyle(color: Color.fromARGB(255, 215, 215, 215))),
        // Add a hamburger icon that opens the drawer
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Choose your game to optimize', style: TextStyle(color: Color.fromARGB(255, 215, 215, 215))),
            buildGameButtons(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            freeram = RamManage.worker().toString();
            showToast(context: context, text: 'Cleaned $freeram MB');
          },
          child: const Text('Clear RAM'),
        ),
      ),
      drawer: const MyDrawerWidget(),
    );
  }

  Widget buildGameButtons() {
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
                    states.contains(MaterialState.focused)) return const Color.fromARGB(255, 85, 130, 255);
                return const Color.fromARGB(255, 255, 255, 255);
              },
            ),
          ),
          onPressed: () {
            int ret = Worker.optimizer(
                gameName); // Assuming Worker.optimizer accepts game names
            setState(() {
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
            });
            showToast(context: context, text: status);
          },
          child: Text(gameName,
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        );
      }).toList(),
    );
  }
}
