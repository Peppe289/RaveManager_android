// ignore_for_file: file_names

import 'dart:io';
import 'Root.dart';
import 'package:system_info/system_info.dart';

class RamManage {
  // ignore: constant_identifier_names
  static const String PATH_CACHE = "/proc/sys/vm/drop_caches";

  static bool clearRam() {
    try {
      ProcessResult result =
          Process.runSync('su', ['-c', 'echo 3 > $PATH_CACHE']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  static void syncData() {
    try {
      // ignore: unused_local_variable
      ProcessResult result = Process.runSync('su', ['-c', 'sync']);
      // ignore: empty_catches
    } catch (e) {}
  }

  static int worker() {
    int before = SysInfo.getFreePhysicalMemory();
    int after;

    if (RootCheck.checkRoot() == false) {
      return 0;
    }

    syncData();
    if (!clearRam()) {
      return 0;
    }

    after = SysInfo.getFreePhysicalMemory();

    double calc = (after - before) / 1000000;

    return calc.round();
  }
}
