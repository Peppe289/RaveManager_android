// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:tweaker/utils/JSON_fetch.dart';
import 'package:just_toast/just_toast.dart';
import 'package:tweaker/utils/versionChecker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class MyDrawerWidget extends StatefulWidget {
  MyDrawerWidget({super.key});

  @override
  _MyDrawerWidget createState() => _MyDrawerWidget();
}

class _MyDrawerWidget extends State<MyDrawerWidget> {
  // ignore: constant_identifier_names
  static const String GITHUB_PROFILE = "https://github.com/Peppe289";
  // ignore: constant_identifier_names
  static const String DONATE_ME = "https://www.paypal.me/GSperanza487";
  late String updateText = "";
  String downloadLink = "";

  Future<void> _launchUrl(String str) async {
    final Uri url = Uri.parse(str);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void checkUpdate(context) async {
    setState(() {
      updateText = "Search for...";
    });

    /// we need to find version for this app,
    /// and later check for online json and compare version.
    VersionChecker versionChecker = await VersionChecker.create();
    String onlineVersion = await JSONfetch.raveVersion(
        "https://raw.githubusercontent.com/Peppe289/RaveManager_android/master/pubspec.yaml");
    if (onlineVersion.isEmpty) {
      updateText = "";
      showToast(
          context: context, text: "Connection error. Please use manual check.");
    }

    /// i put in my personal repository all my link and info using json.
    /// retrieve from this json the link for download new update.
    Map<String, dynamic> info = await JSONfetch.json(
        "https://raw.githubusercontent.com/Peppe289/peppe289.github.io/master/info.json");

    if (onlineVersion.compareTo(versionChecker.version) == 0) {
      if (kDebugMode) {
        print("Latest version already installed.");
      }
      setState(() => updateText = "");
      showToast(context: context, text: "Already on last version.");
    } else {
      if (kDebugMode) {
        print(
            "local version: ${versionChecker.version} - online version: $onlineVersion");
      }
      downloadLink = info["project"]["rave"]["application"].toString();
      setState(() => updateText = "Update");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: AssetImage('assets/wallpaper.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  'By Rave',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Donate Me'),
                onTap: () {
                  _launchUrl(DONATE_ME);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('My GitHub'),
                onTap: () {
                  _launchUrl(GITHUB_PROFILE);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              textColor: Colors.white,
              tileColor: const Color.fromARGB(255, 50, 86, 184),
              title: Text(updateText == "" ? 'Find Update' : updateText,
                  textAlign: TextAlign.center),
              onTap: () {
                if (downloadLink == "") {
                  checkUpdate(context);
                } else {
                  _launchUrl(downloadLink);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
