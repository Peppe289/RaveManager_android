// ignore_for_file: file_names

import 'dart:io';

class RootCheck {

  // ignore: constant_identifier_names
  static const int ROOT_DENIED = -10; 

  static bool checkRoot() {
    try {
      ProcessResult result = Process.runSync('su', ['-c', 'id', '-u']);
      return int.parse(result.stdout) == 0;
    } catch (e) {
      return false;
    }
  }
}
