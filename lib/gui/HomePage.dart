import 'package:flutter/material.dart';

class buildHomePage extends StatelessWidget {
  const buildHomePage({super.key});

  static String freeram = '';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hello')
          ],
        ),
      ),
    );
  }
}
