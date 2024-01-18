// ignore_for_file: file_names

//import 'dart:io';
import 'package:root/root.dart';

class RootCheck {
  // ignore: constant_identifier_names
  static const int ROOT_DENIED = -10;
  bool _status = false;

  Future<void> _checkRoot() async {
    bool? result = await Root.isRootAvailable();
    _status = result!;
  }

  bool checkRoot() {
    _checkRoot();
    return _status;
  }
}
