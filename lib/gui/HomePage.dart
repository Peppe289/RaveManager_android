import 'package:flutter/material.dart';
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
    try {
      _selectedFrequencyMin = Frequency(FrequencyList().currfreqMin());
      _selectedFrequencyMax = Frequency(FrequencyList().currfreqMax());
      list = FrequencyList().availableFreq();
      if (list.first.frequency == -1) {
        isRave = false;
      }
    } catch (e) {
      isRave = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isRave == false) {
      return Scaffold(
        backgroundColor: const Color(0x00121212),
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

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0x00121212),
        appBar: AppBar(
          title: const Text('Rave Settings.'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.center,
            child: Wrap(
              children: [
                /* box shadow and color. */
                Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        // shadow position.
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  /* box size and color. */
                  child: SizedBox(
                    width: 300,
                    height: 150,
                    child: ColoredBox(
                      color: const Color.fromARGB(255, 29, 29, 29),
                      child: Column(
                        /* box items */
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'GPU maximum frequency:',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              DropdownButton<Frequency>(
                                value: _selectedFrequencyMax,
                                onChanged: (Frequency? newValue) {
                                  setState(() {
                                    _selectedFrequencyMax = newValue!;
                                  });

                                  int ret = FrequencyList().updateFrequency(
                                      _selectedFrequencyMax.frequency, 1);
                                  if (ret == 0) {
                                    showToast(
                                        context: context,
                                        text:
                                            "Done. Max GPU freq to: ${_selectedFrequencyMax.frequency} Mhz");
                                  }
                                },
                                dropdownColor:
                                    const Color.fromARGB(255, 18, 18, 18),
                                items: list.map<DropdownMenuItem<Frequency>>(
                                    (Frequency frequency) {
                                  return DropdownMenuItem<Frequency>(
                                    value: frequency,
                                    child: Text(
                                      "${frequency.frequency} Mhz",
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'GPU minimum frequency:',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              DropdownButton<Frequency>(
                                value: _selectedFrequencyMin,
                                onChanged: (Frequency? newValue) {
                                  setState(() {
                                    _selectedFrequencyMin = newValue!;
                                  });

                                  int ret = FrequencyList().updateFrequency(
                                      _selectedFrequencyMin.frequency, -1);
                                  if (ret == 0) {
                                    showToast(
                                        context: context,
                                        text:
                                            "Done. Min GPU freq to: ${_selectedFrequencyMin.frequency} Mhz");
                                  }
                                },
                                dropdownColor:
                                    const Color.fromARGB(255, 18, 18, 18),
                                items: list.map<DropdownMenuItem<Frequency>>(
                                    (Frequency frequency) {
                                  return DropdownMenuItem<Frequency>(
                                    value: frequency,
                                    child: Text(
                                      "${frequency.frequency} Mhz",
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
