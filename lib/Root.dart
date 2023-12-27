import 'dart:io';

class RootCheck {
  static bool checkRoot() {
    try {
      ProcessResult result = Process.runSync('su', ['-c', 'id', '-u']);
      return int.parse(result.stdout) == 0;
    } catch (e) {
      return false;
    }
  }
}
