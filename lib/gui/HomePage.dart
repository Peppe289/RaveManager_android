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

  @override
  bool operator ==(other) => other is Frequency && other.frequency == frequency;

  @override
  int get hashCode => frequency;
}

class FrequencyList {
  List<Frequency> availableFreq() {
    List<Frequency> list = [];

    final lib = DynamicLibrary.open("librave.so");
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int16 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    gpuFreq(0, sizePtr, 0);

    for (int i = 0; i != 10 && sizePtr[i] != 0; ++i) {
      list.add(Frequency((sizePtr[i] / 1000000).round()));
    }

    return list;
  }

  int currfreqMax() {
    final lib = DynamicLibrary.open("librave.so");
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int32 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    return (gpuFreq(0, sizePtr, 1) / 1000000).round();
  }

  int currfreqMin() {
    final lib = DynamicLibrary.open("librave.so");
    final sizePtr = calloc<Int32>(10);
    final gpuFreq = lib.lookupFunction<
        Int32 Function(Int32, Pointer<Int32>, Int16),
        int Function(int, Pointer<Int32>, int)>("adreno_freq");

    return (gpuFreq(0, sizePtr, -1) / 1000000).round();
  }
}

// ignore: camel_case_types
class _BuildHomePage extends State<BuildHomePage> {
  late Frequency _selectedFrequencyMin;
  late Frequency _selectedFrequencyMax;
  late List<Frequency> list;

  @override
  void initState() {
    super.initState();
    _selectedFrequencyMin = Frequency(FrequencyList().currfreqMin());
    _selectedFrequencyMax = Frequency(FrequencyList().currfreqMax());
    list = FrequencyList().availableFreq();
  }

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
                              title: Text("${frequency.frequency} Mhz"),
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
                                gpuFreq(
                                    (_selectedFrequencyMin.frequency * 1000000),
                                    sizePtr,
                                    -1);
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
                              title: Text("${frequency.frequency} Mhz"),
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
                                gpuFreq(
                                    (_selectedFrequencyMax.frequency * 1000000),
                                    sizePtr,
                                    1);
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
