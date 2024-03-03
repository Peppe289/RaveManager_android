// ignore_for_file: file_names

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class MyDrawerWidget extends StatelessWidget {
  const MyDrawerWidget({super.key});

  // ignore: constant_identifier_names
  static const String GITHUB_PROFILE = "https://github.com/Peppe289";
  // ignore: constant_identifier_names
  static const String DONATE_ME = "https://www.paypal.me/GSperanza487";

  Future<void> _launchUrl(String str) async {
    final Uri url = Uri.parse(str);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
    );
  }
}
