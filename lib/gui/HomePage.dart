import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:just_toast/just_toast.dart';
import '../utils/gpu_syscall.dart';

class BuildHomePage extends StatefulWidget {
  const BuildHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuildHomePage createState() => _BuildHomePage();
}

// ignore: camel_case_types
class _BuildHomePage extends State<BuildHomePage> {
  late Frequency _selectedFrequencyMin;
  late Frequency _selectedFrequencyMax;
  late List<Frequency> list;
  bool isRave = true;

  @override
  void initState() {
    super.initState();
    _selectedFrequencyMin = Frequency(FrequencyList().currfreqMin());
    _selectedFrequencyMax = Frequency(FrequencyList().currfreqMax());
    list = FrequencyList().availableFreq();
    if (list.first.frequency == -1) {
      isRave = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isRave == false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('PLS Use Rave Kernel'),
        ),
        body: const Text(
          'The patch is not present in this kernel. use the latest version of Rave.',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      );
    }

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

                                int ret = FrequencyList().updateFrequency(
                                    _selectedFrequencyMax.frequency, 1);
                                if (ret == 0) {
                                  showToast(
                                      context: context,
                                      text:
                                          "Done. Max GPU freq to: ${_selectedFrequencyMax.frequency} Mhz");
                                }
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
            ),
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

                                int ret = FrequencyList().updateFrequency(
                                    _selectedFrequencyMin.frequency, -1);
                                if (ret == 0) {
                                  showToast(
                                      context: context,
                                      text:
                                          "Done. Min GPU freq to: ${_selectedFrequencyMin.frequency} Mhz");
                                }
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
            )
          ],
        ),
      ),
    );
  }
}
