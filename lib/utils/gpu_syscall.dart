import 'dart:ffi';
import 'package:ffi/ffi.dart';

// base class for frequency
class Frequency {
  int frequency;
  Frequency(this.frequency);

  @override
  bool operator ==(other) => other is Frequency && other.frequency == frequency;

  @override
  int get hashCode => frequency;
}

// Need for manage list in radio menu button. Here list of all available GPU frequency
class FrequencyList {
  List<Frequency> availableFreq() {
    List<Frequency> list = [];

    // load dynamic library for invoke syscall
    final lib = DynamicLibrary.open("librave.so");
    // 10 is max GPU freq step possibile in kernel
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int16 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    // check if syscall runned fine or not. list.first.frequency == -1 means error
    if (gpuFreq(0, sizePtr, 0) < 0) {
      list.add(Frequency(-1));
      calloc.free(sizePtr);
      return list;
    }

    // convert hz to mhz (is better for user)
    for (int i = 0; i != 10 && sizePtr[i] != 0; ++i) {
      list.add(Frequency((sizePtr[i] / 1000000).round()));
    }

    calloc.free(sizePtr);
    return list;
  }

  // need for default in init.
  int currfreqMax() {
    final lib = DynamicLibrary.open("librave.so");
    // 10 is max GPU freq step possibile in kernel
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int32 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    int max = (gpuFreq(0, sizePtr, 1) / 1000000).round();
    calloc.free(sizePtr);
    return max;
  }

  // need for default in init.
  int currfreqMin() {
    final lib = DynamicLibrary.open("librave.so");
    // 10 is max GPU freq step possibile in kernel
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int32 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    int min = (gpuFreq(0, sizePtr, -1) / 1000000).round();
    calloc.free(sizePtr);
    return min;
  }

  int updateFrequency(int frequency, int flag) {
    final lib = DynamicLibrary.open("librave.so");
    // 10 is max GPU freq step possibile in kernel
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int16 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");
    int ret = gpuFreq((frequency * 1000000), sizePtr, flag);
    calloc.free(sizePtr);
    return ret;
  }
}
