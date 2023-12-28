// ignore_for_file: file_names

import 'dart:io';
import 'Root.dart';

class Gpu {
  // ignore: constant_identifier_names
  static const String GPU_USAGE_KEY = "gpu_busy_percentage";
  // ignore: non_constant_identifier_names
  static String gpu_usage_path = '';
  static bool isInit = false;

  static String getPath(String find) {
    if (RootCheck.checkRoot() == false) {
      return '';
    }

    try {
      ProcessResult result =
          Process.runSync('su', ['-c', 'find', '/sys', '-name', find]);
      if (result.exitCode == 0) {
        return result.stdout;
      }
    } catch (e) {
      return 'error';
    }

    return 'error';
  }

  static void init() {
    if (isInit == true) {
      return;
    }

    gpu_usage_path = getPath(GPU_USAGE_KEY);
  }

  static String usage() {
    if (isInit == false) {
      init();
    }

    try {
      ProcessResult result =
          Process.runSync('su', ['-c', 'cat', gpu_usage_path]);

      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (e) {
      return 'Error';
    }

    return 'Error';
  }
}
