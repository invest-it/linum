import 'package:args/args.dart';
import 'package:translation_script/translate.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption("dir", abbr: "d", help: "directory for language files", defaultsTo: "lang")
    ..addOption("base", abbr: "b", help: "Base file with configurations and keys", defaultsTo: "base.json")
    ..addOption("compare", abbr: "c", help: "File the base file is compared against", defaultsTo: "de-DE.json")
    ..addFlag("single", abbr: "s", help: "Only update the compared file");

  final args = parser.parse(arguments);



  await generateTranslations(args);
}
