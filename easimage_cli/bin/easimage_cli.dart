import 'package:args/args.dart';
import 'package:easimage_lib/easimage_lib.dart';

ArgParser buildParser() {
  return ArgParser();
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();

  var duplicate = argParser..addCommand('duplicate');
  duplicate.addFlag(
    'threshold',
    abbr: 't',
  );
  duplicate.addFlag('input', abbr: 'i');

  final ArgResults results = argParser.parse(arguments);

  if (results.command!['duplicate']) {
    Future<List<String>> imagePath = detectImages(results.arguments.first);

    DuplicateFinder finder = DuplicateFinder();
    List<ImageDesciptor> images =
        (await imagePath).map((p) => ImageDesciptor(p)).toList();
    List<Duplicate> duplicates = finder.find(images);

    int threshold = results['threshold'] as int;
    print(duplicates.where((element) => element.score > threshold).toList());
  }
}
