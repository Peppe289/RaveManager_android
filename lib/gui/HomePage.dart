import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:just_toast/just_toast.dart';

class BuildHomePage extends StatefulWidget {
  const BuildHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuildHomePage createState() => _BuildHomePage();
}

class Frequency {
  int frequency;
  Frequency(this.frequency);
}

class FrequencyList {
  List<Frequency> AvailableFreq() {
    List<Frequency> list = [];

    final lib = DynamicLibrary.open("librave.so");
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int16 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    gpuFreq(0, sizePtr, 0);

    for (int i = 0; i != 10 && sizePtr[i] != 0; ++i) {
      list.add(Frequency(sizePtr[i]));
    }

    return list;
  }
  /*
  int currfreq_max() {
    final lib = DynamicLibrary.open("librave.so");
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int32 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    return gpuFreq(0, sizePtr, 1);
  }

  int currfreq_min() {
    final lib = DynamicLibrary.open("librave.so");
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int32 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    return gpuFreq(0, sizePtr, -1);
  }*/
}

// ignore: camel_case_types
class _BuildHomePage extends State<BuildHomePage> {
  @override
  void initState() {
    super.initState();
  }

  // default is not possible to know rn
  Frequency _selectedFrequencyMin = Frequency(-1);
  Frequency _selectedFrequencyMax = Frequency(-1);
  List<Frequency> list = FrequencyList().AvailableFreq();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rave Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('GPU minimum frequency'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: list.map((frequency) {
                            return RadioListTile<Frequency>(
                              title: Text(frequency.frequency.toString()),
                              value: frequency,
                              groupValue: _selectedFrequencyMin,
                              onChanged: (Frequency? value) {
                                setState(() {
                                  _selectedFrequencyMin = value!;
                                });
                                Navigator.of(context).pop();
                                showToast(
                                    context: context,
                                    text:
                                        "Setted ${_selectedFrequencyMin.frequency}");
                                final lib = DynamicLibrary.open("librave.so");
                                final sizePtr = calloc<Int32>(10);
                                final gpuFreq = lib.lookupFunction<
                                    Int16 Function(
                                        Int32, Pointer<Int32>, Int16),
                                    int Function(int, Pointer<Int32>,
                                        int)>("adreno_freq");
                                gpuFreq(_selectedFrequencyMin.frequency,
                                    sizePtr, -1);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('GPU minimum frequency'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('GPU maximum frequency'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: list.map((frequency) {
                            return RadioListTile<Frequency>(
                              title: Text(frequency.frequency.toString()),
                              value: frequency,
                              groupValue: _selectedFrequencyMax,
                              onChanged: (Frequency? value) {
                                setState(() {
                                  _selectedFrequencyMax = value!;
                                });
                                Navigator.of(context).pop();
                                showToast(
                                    context: context,
                                    text:
                                        "Setted ${_selectedFrequencyMax.frequency}");
                                final lib = DynamicLibrary.open("librave.so");
                                final sizePtr = calloc<Int32>(10);
                                final gpuFreq = lib.lookupFunction<
                                    Int16 Function(
                                        Int32, Pointer<Int32>, Int16),
                                    int Function(int, Pointer<Int32>,
                                        int)>("adreno_freq");
                                gpuFreq(_selectedFrequencyMax.frequency,
                                    sizePtr, 1);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('GPU maximum frequency'),
            )
          ],
        ),
      ),
    );
  }
}
