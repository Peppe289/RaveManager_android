// ignore_for_file: file_names

import 'Root.dart';
import 'dart:io';
import 'Sched.dart';

class Worker {
  // ignore: constant_identifier_names
  static const int ERROR = Scheduler.ERROR;
  // ignore: constant_identifier_names
  static const String PUBG_MOBILE_PKG = "com.tencent.ig";
  // ignore: constant_identifier_names
  static const String BGMI_INDIA_PKG = "com.pubg.imobile";
  // ignore: constant_identifier_names
  static const String PUBG_MOBILE_LITE_PKG = "com.tencent.iglite";
  // ignore: constant_identifier_names
  static const String PUBG_MOBILE = "PUBG Mobile";
  // ignore: constant_identifier_names
  static const String BGMI_INDIA = "BGMI India";
  // ignore: constant_identifier_names
  static const String PUBG_MOBILE_LITE = "PUBG Mobile Lite";
  
  // ignore: non_constant_identifier_names
  static String process_ID = '';
  static String pkg = '';

  static String getPackages(String str) {
    String result;

    switch (str) {
      case PUBG_MOBILE:
        result = PUBG_MOBILE_PKG;
        break;
      case BGMI_INDIA:
        result = BGMI_INDIA_PKG;
        break;
      case PUBG_MOBILE_LITE:
        result = PUBG_MOBILE_LITE_PKG;
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

      if (result.exitCode == 0) {
        ret = result.stdout.toString().trim();
      } else {
        ret = "";
      }
    } catch (e) {
      return "";
    }

    return ret;
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
      return RootCheck.ROOT_DENIED;
    }

    process_ID = checkRunning(str);

    /**
     * -o: SCHED_OTHER 0/0
     * -f: SCHED_FIFO 1/99
     * -r: SCHED_RR 1/99
     * -b: SCHED_BATCH 0/0
     * -i: SCHED_IDLE 0/0
     * 
     * TODO:
     * Deadline isn't present in my machine (I will find for this)
     */
    return Scheduler.setScheduler(process_ID, '-b', '0');
  }
}
