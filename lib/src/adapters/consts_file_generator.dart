import 'dart:io';

import 'constant_creator.dart';

class ConstsFileGenerator {
  final String path;
  final String filename;
  final ConstantCreator constCreator;
  ConstsFileGenerator({
    required this.path,
    required this.filename,
    required this.constCreator,
  });
  void generateFile() async {
    var file = await File('$path/$filename').create(recursive: true);
    file.writeAsStringSync(constCreator.genFileHeader());
    constCreator.generateConstants().listen((event) {
      stdout.write('Saved To File: $event');
      file.writeAsStringSync(event, mode: FileMode.writeOnlyAppend);
    });
  }
}
