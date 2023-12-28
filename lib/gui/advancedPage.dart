// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../utils/RamManage.dart';
import 'package:just_toast/just_toast.dart';
import 'package:system_info2/system_info2.dart';

// ignore: camel_case_types
class buildSecondPage extends StatelessWidget {
  const buildSecondPage({super.key});

  static String freeram = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildRow('Kernel Version:', SysInfo.kernelVersion),
            buildRow('Architecture:', SysInfo.kernelArchitecture.toString()),
            buildRow('Physical Memory Size:', '${(SysInfo.getTotalPhysicalMemory() / 1000000).truncate()} MB'),
            buildRow('Virtual Memory Size:', '${(SysInfo.getTotalVirtualMemory() / 1000000).truncate()} MB'),
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
    );
  }

  Widget buildRow(String leftText, String rightParam) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leftText,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            rightParam,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
