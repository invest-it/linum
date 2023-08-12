//  Settings Screen Version Number - Version Number
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  Refactored: TheBlueBaron

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';




class VersionNumber extends StatefulWidget {
  @override
  State<VersionNumber> createState() => _VersionNumberState();
}

class _VersionNumberState extends State<VersionNumber> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        '${_packageInfo.appName} Version ${_packageInfo.version} (${_packageInfo.buildNumber})',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              letterSpacing: 0,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
