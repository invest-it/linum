//  URL Handler - Launches URLs in the integrated Browser
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:url_launcher/url_launcher.dart';

// Launches URLS in the standard browser. Helpful for Buttons etc.
// usage: e.g. onTap: launchURL('https://onlyfans.com')

// Generate an Uri out of an ordinary string

Uri fromString(String input) {
  return Uri.parse(input);
}

// To test whether the link has been opened, read out the Future<bool> return value of launchURL().

// ignore: avoid_void_async
void launchURL(
  String url, {
  LaunchMode mode = LaunchMode.externalApplication,
}) async {
  if (!await launchUrl(
    fromString(url),
    mode: mode,
  )) {
    throw 'Could not launch $url';
  }
}
