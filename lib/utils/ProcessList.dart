// ignore_for_file: file_names

//import 'dart:io';
import 'dart:convert';
import 'dart:ffi';
import 'package:root/root.dart';

class ProcessList {
  late String name;
  late int pid;
  late int virt;
  late int res;

  ProcessList(this.name, this.pid, this.virt, this.res);

  String getName() {
    return name;
  }

  int getPid() {
    return pid;
  }

  int getVirt() {
    return virt;
  }

  int getRes() {
    return res;
  }
}

class LoadProcessList {
  late List<int> pid;
  late List<ProcessList> full = [];

  void updateList() async {
    String? res;
    try {
      res = await Root.exec(cmd: "ps -e -o pid,cmd");
    } catch (e) {
      full.add(ProcessList('Err', 0, 0, 0));
      return;
    }

      List<String> output =
          LineSplitter.split(res as String).toList();
      full.clear();
      for (var line in output) {
        List<String> split = line.trim().toString().split(' ');
        // is first line. we don't need this
        if (split[0].compareTo("PID") == 0) {
          continue;
        }
        int pid = int.parse(split[0]);
        int virt = 0;
        int res = 0;

        final lib = DynamicLibrary.open("librave.so");
        final uselib = lib.lookupFunction<Int32 Function(), int Function()>("someData");

        full.add(ProcessList(split[1], uselib(), virt, res));
      }
    

    return;
  }

  List<ProcessList> getList() {
    return full;
  }

  int getLength() {
    return full.length;
  }
}
