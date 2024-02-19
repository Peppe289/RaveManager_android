// ignore_for_file: file_names

//import 'dart:io';
import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:math';
import 'package:root/root.dart';
import 'dart:convert';

class ProcessList {
  late String name;
  late int pid;
  late int virt;
  late int res;

  ProcessList(this.name, this.pid, this.virt, this.res);

  String getName() {
    return name;
  }

  int getPid() {
    return pid;
  }

  int getVirt() {
    return virt;
  }

  int getRes() {
    return res;
  }
}

final class TaskSimplyStruct extends Struct {
  @Int32()
  external int pid;

  @Array(16)
  external Array<Uint8> comm;
}

class LoadProcessList {
  late List<int> pid;
  late List<ProcessList> full = [];

  void updateList() async {
    full.clear();

    final lib = DynamicLibrary.open("librave.so");
    final sizePtr = calloc<Int32>();
    final taskList = lib.lookupFunction<
        Pointer<TaskSimplyStruct> Function(Pointer<Int32>),
        Pointer<TaskSimplyStruct> Function(Pointer<Int32>)>("task_list");

    Pointer<TaskSimplyStruct> resultPtr = taskList(sizePtr);
 
    for (int i = 0; i < sizePtr[0]; ++i) {
      int virt = 0;
      int res = 0;

      Array<Uint8> tmp = resultPtr[i].comm;
      List<int> stInt32 = [];
      for (int k = 0; k < 16; ++k) {
        stInt32.add(tmp[k]);
      }

      full.add(ProcessList(utf8.decode(stInt32), resultPtr[i].pid, virt, res));
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
