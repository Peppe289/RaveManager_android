import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';

class BuildHWInfoPage extends StatefulWidget {
  const BuildHWInfoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuildHWInfoPage createState() => _BuildHWInfoPage();
}

class _BuildHWInfoPage extends State<BuildHWInfoPage> {
  static String _physicalMemory = "loading...";
  static String _virtualMemory = "loading...";
  static String _cpuVendor = "loading...";
  static String _archName = "loading...";

  @override
  void initState() {
    super.initState();
    _physicalMemory =
        (SysInfo.getTotalPhysicalMemory() / 1000000).truncate().toString();
    _virtualMemory =
        (SysInfo.getTotalVirtualMemory() / 1000000).truncate().toString();
    _cpuVendor = SysInfo.cores.first.vendor;
    _archName = SysInfo.cores.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildRow('Physical Memory Size:', '$_physicalMemory MB'),
            buildRow('Virtual Memory Size:', '$_virtualMemory MB'),
            buildRow('CPU Vendor:', _cpuVendor),
            buildRow('Architecture Name:', _archName),
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
