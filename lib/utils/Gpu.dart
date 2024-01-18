// ignore_for_file: file_names

import 'dart:io';
import 'Root.dart';

class Gpu {
  // ignore: constant_identifier_names
  static const String GPU_USAGE_KEY = "gpu_busy_percentage";
  // ignore: constant_identifier_names
  static const String GPU_MODEL_KEY = "gpu_model";
  // ignore: non_constant_identifier_names
  static String gpu_usage_path = '';
  // ignore: non_constant_identifier_names
  static String gpu_model_path = '';
  static bool isInit = false;

  static String getPath(String find) {
    if (RootCheck.checkRoot() == false) {
      return '';
    }

    try {
      ProcessResult result =
          Process.runSync('su', ['-c', 'find /sys -name $find']);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
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
    isInit = true;
  }

  static String usage() {
    if (isInit == false) {
      init();
    }

    try {
      ProcessResult result =
          Process.runSync('su', ['-c', 'cat $gpu_usage_path']);

      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (e) {
      return 'Error';
    }

    return 'Error';
  }

  static String model() {
    // can be have than more 1 node. I need just one node
    gpu_model_path = getPath(GPU_MODEL_KEY).split('\n').first;

    try {
      ProcessResult result =
          Process.runSync('su', ['-c', 'cat $gpu_model_path']);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (e) {
      return 'Error';
    }

    return 'Error';
  }
}
