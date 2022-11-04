import 'dart:io';

bool continueTranslating() {
  stdout.write("Continue translating? (yes/no): ");
  final userInput = stdin.readLineSync();
  if (userInput?.toUpperCase() == "NO" || userInput?.toUpperCase() == "N") {
    stdout.write("Exiting without translating..");
    sleep(const Duration(seconds: 2));
    return false;
  }

  if (userInput?.toUpperCase() == "YES" || userInput?.toUpperCase() == "Y") {
    stdout.writeln("Continuing..");
    sleep(const Duration(seconds: 1));
    return true;
  } else {
    stdout.writeln("Please enter yes or no.");
    return continueTranslating();
  }
}
