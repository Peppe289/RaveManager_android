import 'package:client_information/client_information.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';

class BuildSoftwareInfoPage extends StatefulWidget {
  const BuildSoftwareInfoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuildSoftwareInfoPage createState() => _BuildSoftwareInfoPage();
}

class _BuildSoftwareInfoPage extends State<BuildSoftwareInfoPage> {
  static String _deviceID = "loading...";
  static String _deviceModel = "loading...";
  static String _manufacturer = "loading...";
  static String _androidVersion = "loading...";
  static String _tags = "loading...";
  static String _boardName = "loading...";
  static String _display = "loading...";
  static String _buildType = "loading...";
  static String _kernelVersion = "loading...";
  static String _appVersion = "loading...";
  static String _appName = "loading...";

  Future<void> retrieveAppInfo() async {
    ClientInformation clientInfo = await ClientInformation.fetch();
    setState(() {
      _appVersion = clientInfo.softwareVersion;
      _appName = clientInfo.softwareName;
    });
  }

  Future<void> retrieveDevicesInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _deviceID = androidInfo.id;
      _deviceModel = androidInfo.model;
      _manufacturer = androidInfo.manufacturer;
      _androidVersion = androidInfo.version.release;
      _tags = androidInfo.tags;
      _boardName = androidInfo.board;
      _display = androidInfo.display;
      _buildType = androidInfo.type;
      _kernelVersion = SysInfo.kernelVersion;
    });

    if (kDebugMode) {
      print("load information from devices with ID: $_deviceID");
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveDevicesInfo();
    retrieveAppInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildRow("Android Version ID:", _deviceID),
            buildRow("Device Model:", _deviceModel),
            buildRow("Device Manufacturer:", _manufacturer),
            buildRow("Android Version", _androidVersion),
            buildRow("Tags:", _tags),
            buildRow("BoardName:", _boardName),
            buildRow("Display:", _display),
            buildRow("Build Type:", _buildType),
            buildRow("Kernel Version:", _kernelVersion),
            buildRow("App version:", _appVersion),
            buildRow("App Name:", _appName),
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
          Expanded(
            child: Text(
              leftText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              rightParam,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.right, // Align text to the right
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
