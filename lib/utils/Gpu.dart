// ignore_for_file: file_names

//import 'dart:io';
import 'isRoot.dart';
import 'package:root/root.dart';

class Gpu {
  // ignore: constant_identifier_names
  static const String GPU_USAGE_KEY = "gpu_busy_percentage";
  // ignore: constant_identifier_names
  static const String GPU_MODEL_KEY = "gpu_model";
  // ignore: non_constant_identifier_names
  static String gpu_usage_path = '';
  // ignore: non_constant_identifier_names
  static String gpu_model_path = '';
  // ignore: non_constant_identifier_names
  static String gpu_model = '';
  // ignore: non_constant_identifier_names
  static String gpu_usage = '';
  static bool isInit = false;

  static Future<void> getPath(String find) async {
    RootCheck isRoot = RootCheck();
    String? result;

    if (isRoot.checkRoot() == false) {
      gpu_model_path = '';
    }

    try {
      result = await Root.exec(cmd: 'find /sys -name $find 2> /dev/null');
    } catch (e) {
      result = 'error';
    }

    switch (find) {
      case GPU_MODEL_KEY:
        // can be have than more 1 node. I need just one node
        gpu_model_path = result.toString().trim().split('\n').first;
        break;
      case GPU_USAGE_KEY:
        gpu_usage_path = result.toString().trim();
        break;
      default:
        return;
    }
  }

  static void init() {
    if (isInit == true) {
      return;
    }
    getPath(GPU_USAGE_KEY);
    getPath(GPU_MODEL_KEY);
    isInit = true;
  }

  static Future<void> _usage() async {
    init();

    if (gpu_usage_path.isEmpty) {
      gpu_usage = "Error";
      return;
    }

    try {
      String? result = await Root.exec(cmd: 'cat $gpu_usage_path');

      gpu_usage = result.toString().trim();
    } catch (e) {
      gpu_usage = 'Error';
    }
  }

  static String usage() {
    _usage();
    return gpu_usage;
  }

  static Future<void> _model() async {
    if (gpu_model_path.isEmpty) {
      gpu_model = 'Error';
      return;
    }

    try {
      String? result = await Root.exec(cmd: 'cat $gpu_model_path');
      gpu_model = result.toString().trim();
    } catch (e) {
      gpu_model = 'Error';
    }
  }

  static String model() {
    if (gpu_model.compareTo('') == 0) {
      _model();
    }
    return gpu_model;
  }
}
