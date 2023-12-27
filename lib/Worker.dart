import 'Root.dart';
import 'dart:io';

class Worker {
  // ignore: constant_identifier_names
  static const String PUBG_MOBILE_PKG = "com.tencent.ig";
  // ignore: constant_identifier_names
  static const String PUBG_MOBILE = "PUBG Mobile";
  // ignore: non_constant_identifier_names
  static String process_ID = '';
  static String pkg = '';

  static String getPackages(String str) {
    String result;

    switch (str) {
      case PUBG_MOBILE:
        result = PUBG_MOBILE_PKG;
        break;
      default:
        result = Null as String;
    }

    return result;
  }

  static String getPid(String str) {
    String ret;

    try {
      ProcessResult result = Process.runSync('su', ['-c', 'pidof', str]);
      ret = result.stdout.toString().trim();

      if (result.exitCode == 0) {
        return ret;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }
  

  static bool validatePermission() {
    return RootCheck.checkRoot();
  }

  static String checkRunning(String str) {
    // search for packages running
    pkg = getPackages(str);
    return getPid(pkg);
  }

  static int optimizer(String str) {
    if (validatePermission() == false) {
      return -2;
    }

    process_ID = checkRunning(str);

    try {
      ProcessResult result =
          Process.runSync('su', ['-c', 'chrt', '-p', process_ID, '-b', '0']);
      return result.exitCode;
    } catch (e) {
      return -2;
    }
  }
}
