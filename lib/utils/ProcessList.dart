// ignore_for_file: file_names
import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

/// @pid: process id
/// @comm: name of process
/// @rssMemory: resident memory used
/// @vm: virtual memor
final class TaskSimplyStruct extends Struct {
  @Int32()
  external int pid;

  @Array(16)
  external Array<Uint8> comm;

  @Int64()
  external int rssMemory;

  @Int64()
  external int vm;
}

class LoadProcessList {
  late List<int> pid;
  // List of all process (take from PCB)
  late List<ProcessList> full = [];
  bool showThread = false;

  // ignore: non_constant_identifier_names
  List<int> convert_Uint8_to_int(Array<Uint8> data) {
    Array<Uint8> tmp = data;
    List<int> stInt32 = [];

    // 16 is for comm[16] in the kernel structure about PCB
    for (int k = 0; k < 16; ++k) {
      stInt32.add(tmp[k]);
    }

    return stInt32;
  }

  void updateList(bool showThread) async {
    full.clear();

    final lib = DynamicLibrary.open("librave.so");
    final sizePtr = calloc<Int32>();
    final taskList = lib.lookupFunction<
        Pointer<TaskSimplyStruct> Function(Pointer<Int32>),
        Pointer<TaskSimplyStruct> Function(Pointer<Int32>)>("task_list");

    Pointer<TaskSimplyStruct> resultPtr = taskList(sizePtr);

    for (int i = 0; i < sizePtr[0]; ++i) {
      double virt = (resultPtr[i].vm.toUnsigned(64) / (1024 * 1024 * 1024));
      double rss =
          (resultPtr[i].rssMemory.toUnsigned(64) / (1024 * 1024 * 1024));

      // thread not have memory usage
      if (showThread == false && virt == 0 && rss == 0) continue;

      full.add(ProcessList(utf8.decode(convert_Uint8_to_int(resultPtr[i].comm)),
          resultPtr[i].pid, virt, rss));
    }

    calloc.free(sizePtr);
    calloc.free(resultPtr);
    return;
  }

  List<ProcessList> getList() {
    return full;
  }

  int getLength() {
    return full.length;
  }
}

class ProcessList {
  late String name;
  late int pid;
  late double virt;
  late double res;

  ProcessList(this.name, this.pid, this.virt, this.res);

  String getName() {
    return name;
  }

  int getPid() {
    return pid;
  }

  double getVirt() {
    return virt;
  }

  double getRes() {
    return res;
  }
}
