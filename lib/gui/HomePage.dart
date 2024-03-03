// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tweaker/utils/RamManage.dart';
import 'dart:async';

class BuildHomePage extends StatefulWidget {
  const BuildHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuildHomePage createState() => _BuildHomePage();
}

// ignore: camel_case_types
class _BuildHomePage extends State<BuildHomePage> {
  bool btn1 = false;

  static const Color activeColor = Color.fromARGB(255, 52, 199, 89);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  int ramUsage = 0;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // Check if the widget is still mounted before updating the state
      if (mounted) {
        setState(() {
          ramUsage = RamManage.usedMemoryPercent();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  // need to fix size
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                  ),
                  const SizedBox(
                    child: Text(
                      "Ram Usage",
                      style:
                          TextStyle(color: Color.fromARGB(255, 247, 237, 237)),
                    ),
                  ),
                  SizedBox(
                    child: LinearPercentIndicator(
                      // need for LinearPercentIndicator
                      width: MediaQuery.of(context).size.width * 0.15,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 200,
                      percent: (ramUsage / 100),
                      center: Text("$ramUsage%"),
                      // ignore: deprecated_member_use
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: const Color.fromARGB(255, 105, 208, 240),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  // need to fix size
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                  ),
                  const SizedBox(
                    child: Text(
                      "Inactive Button",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    //width: MediaQuery.of(context).size.width * 0.15,
                    child: ShaderMask(
                      child: CupertinoSwitch(
                        activeColor: activeColor,
                        //thumbColor: value ? Colors.white : Colors.amber,
                        trackColor: Colors.white70,
                        value: btn1,
                        onChanged: (v) => setState(() {
                          btn1 = v;
                        }),
                      ),
                      shaderCallback: (r) {
                        return LinearGradient(
                          colors: btn1
                              ? [activeColor, activeColor]
                              : [
                                  const Color.fromARGB(255, 211, 211, 211),
                                  const Color.fromARGB(255, 185, 185, 185)
                                ],
                        ).createShader(r);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //Center(
      //  child: ShaderMask(
      //    child: CupertinoSwitch(
      //      activeColor: activeColor,
      //      //thumbColor: value ? Colors.white : Colors.amber,
      //      trackColor: Colors.white70,
      //      value: value,
      //      onChanged: (v) => setState(() {
      //        value = v;
      //      }),
      //    ),
      //    shaderCallback: (r) {
      //      return LinearGradient(
      //        colors: value
      //            ? [activeColor, activeColor]
      //            : [
      //                const Color.fromARGB(255, 211, 211, 211),
      //                const Color.fromARGB(255, 185, 185, 185)
      //              ],
      //      ).createShader(r);
      //    },
      //  ),
      //),
    );
  }
}
