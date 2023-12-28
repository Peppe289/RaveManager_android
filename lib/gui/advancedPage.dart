// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/RamManage.dart';
import 'package:just_toast/just_toast.dart';
import 'package:system_info2/system_info2.dart';
import '../utils/Gpu.dart';

// ignore: camel_case_types
class buildSecondPage extends StatelessWidget {
  const buildSecondPage({super.key});

  static String freeram = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildRow('Kernel Version:', SysInfo.kernelVersion),
            buildRow('Architecture:', SysInfo.kernelArchitecture.toString()),
            buildRow('Physical Memory Size:',
                '${(SysInfo.getTotalPhysicalMemory() / 1000000).truncate()} MB'),
            buildRow('Virtual Memory Size:',
                '${(SysInfo.getTotalVirtualMemory() / 1000000).truncate()} MB'),
            buildRow('CPU Vendor:', SysInfo.cores.first.vendor),
            buildRow('Architecture Name:', SysInfo.cores.first.name),
            buildRow('GPU Model:', Gpu.model()),
            const FrequencyWidget(),
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

/// For dynamic update
class FrequencyWidget extends StatefulWidget {
  const FrequencyWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FrequencyWidgetState createState() => _FrequencyWidgetState();
}

class _FrequencyWidgetState extends State<FrequencyWidget> {
  // ignore: non_constant_identifier_names
  String gpu_usage = 'Loading...';

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // Check if the widget is still mounted before updating the state
      setState(() {
        gpu_usage = Gpu.usage();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildRow('GPU Usage:', gpu_usage);
  }

  Widget buildRow(String leftText, String rightParam) {
    //String paddedRightParam = rightParam.padRight(10);

    return Padding(
      padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            leftText,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            //paddedRightParam,
            rightParam,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
