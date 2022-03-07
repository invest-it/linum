import 'dart:developer';

import 'package:linum/providers/screen_index_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

// Launches URLS in the standard browser. Helpful for Buttons etc.
// usage: e.g. onTap: launchURL('https://onlyfans.com')

// To test whether the link has been opened, read out the Future<bool> return value of launchURL().

Future<bool> launchURL(String url) async {
  if (await canLaunch(url)) {
    return launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
