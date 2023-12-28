// ignore_for_file: file_names

import 'dart:io';

class Scheduler {
  // ignore: constant_identifier_names
  static const int ERROR = -2;
  static int setScheduler(String pid, String policy, String priority) {
    try {
      ProcessResult result =
          Process.runSync('su', ['-c', 'chrt', '-p', pid, policy, priority]);
      return result.exitCode;
    } catch (e) {
      return ERROR;
    }
  }
}