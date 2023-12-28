// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../utils/RamManage.dart';
import 'package:just_toast/just_toast.dart';

// ignore: camel_case_types
class buildSecondPage extends StatelessWidget {
  const buildSecondPage({super.key});

  static String freeram = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Advanced Page for manage settings',
            style: TextStyle(color: Colors.white)),
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
    );
  }
}
