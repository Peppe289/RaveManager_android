// ignore_for_file: file_names

import 'dart:io';
import 'dart:convert';

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

  bool containsOnlyNumbers(String input) {
    try {
      int.parse(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateList() {
    ProcessResult result;
    full.clear();
    try {
      result = Process.runSync('su', ['-c', 'ps -e -o pid,cmd']);
    } catch (e) {
      full.add(ProcessList('Err', 0, 0, 0));
      return;
    }

    if (result.exitCode == 0) {
      List<String> output =
          LineSplitter.split(result.stdout as String).toList();
      for (var line in output) {
        List<String> split = line.trim().toString().split(' ');
        // is first line. we don't need this
        if (split[0].compareTo("PID") == 0) {
          continue;
        }
        int pid = int.parse(split[0]);
        int virt = 0;
        int res = 0;

        try {
          result = Process.runSync('su', ['-c', 'cat /proc/$pid/status']);
          List<String> output = LineSplitter.split(result.stdout as String).toList();
          for (String item in output) { 
            List<String> data = item.trim().toString().split(' ');
            if (data[0].compareTo("VmRSS") == 0) {
              res = int.parse(data[1]);
            } else if (data[0].compareTo("VmSize") == 0) {
              virt = int.parse(data[1]);
            }
          }
        } catch (e) {
          virt = 0;
          res = 0;
        }

        full.add(ProcessList(split[1], pid, virt, res));
      }
    } else {
      full.add(ProcessList('Err', 0, 0, 0));
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
