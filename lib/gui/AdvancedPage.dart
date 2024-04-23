import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';

class buildSecondPage extends StatelessWidget {
  const buildSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // remove kernel version for now
            //buildRow('Kernel Version:', SysInfo.kernelVersion),
            buildRow('Architecture:', SysInfo.kernelArchitecture.toString()),
            buildRow('Physical Memory Size:',
                '${(SysInfo.getTotalPhysicalMemory() / 1000000).truncate()} MB'),
            buildRow('Virtual Memory Size:',
                '${(SysInfo.getTotalVirtualMemory() / 1000000).truncate()} MB'),
            buildRow('CPU Vendor:', SysInfo.cores.first.vendor),
            buildRow('Architecture Name:', SysInfo.cores.first.name),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String leftText, String rightParam) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leftText,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            rightParam,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
