// ignore_for_file: file_names

import 'dart:io';
import 'package:system_info/system_info.dart';

class RamManage {
  // ignore: constant_identifier_names
  static const String PATH_CACHE = "/proc/sys/vm/drop_caches";

  static void clearRam() {
    try {
      // ignore: unused_local_variable
      ProcessResult result =
          Process.runSync('su', ['-c', 'echo 3 > $PATH_CACHE']);
      // ignore: empty_catches
    } catch (e) {}
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

    syncData();
    clearRam();

    after = SysInfo.getFreePhysicalMemory();

    double calc = (after - before) / 1000000;

    return calc.round();
  }

  static int usedMemoryPercent() {
    int usedMemory =
        SysInfo.getTotalPhysicalMemory() - SysInfo.getFreePhysicalMemory();
    int ret;

    ret = ((usedMemory * 100) ~/ SysInfo.getTotalPhysicalMemory());

    return ret;
  }
}
