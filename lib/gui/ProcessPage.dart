// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:async';
//import '../utils/Worker.dart';
//import '../utils/Root.dart';
//import 'package:just_toast/just_toast.dart';
import '../utils/ProcessList.dart';

import 'package:root/root.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProcessPage createState() => _ProcessPage();
}

class _ProcessPage extends State<ProcessPage> {
  LoadProcessList processList = LoadProcessList();
  late List<ProcessList> list;
  late String showProcessText = processList.showThread ? 'Thread' : 'Process';

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateList();
    });
  }

  bool _status = false;

  Future<void> checkRoot() async {
    bool? result = await Root.isRooted();
    setState(() {
      _status = result!;
    });
  }

  void updateList() {
    if (mounted) {
      checkRoot();
      if (_status) {
        setState(() {
          //.add('newItem');
          processList.updateList(processList.showThread);
          list = processList.getList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> title = ['Name', 'PID', 'VIRT', 'RES'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Process List'),
        actions: <Widget>[
          IconButton(
            icon: Text(showProcessText),
            onPressed: () {
              processList.showThread = !processList.showThread;
              setState(() {
                if (processList.showThread) {
                  showProcessText = 'Thread';
                } else {
                  showProcessText = 'Process';
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return Text(title[index],
                    style: const TextStyle(color: Colors.white));
              }),
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                return Column(
                  children: List.generate(
                    processList.getLength(),
                    (index) => buildRow(
                        list[index].getName(),
                        list[index].getPid(),
                        list[index].getVirt(),
                        list[index].getRes()),
                  ),
                );
              },
              future: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String name, int pid, int virt, int res) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black26,
              child: Text(
                name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Container(
                color: Colors.black26,
                child: Text(
                  pid.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Container(
                color: Colors.black26,
                child: Text(
                  virt.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Container(
                color: Colors.black26,
                child: Text(
                  res.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
