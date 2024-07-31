import 'package:package_info_plus/package_info_plus.dart';

/// get info about installed packages.
class VersionChecker {
  String appName;
  String packageName;
  String version;
  String buildNumber;

  VersionChecker({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  static Future<VersionChecker> create() async {
    final packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.version);
    return VersionChecker(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }
}
