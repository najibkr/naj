import 'dart:io';

import '../usecases/request_model.dart';

class FileGenerator {
  const FileGenerator();

  void createDirectory(String directory, [bool recursive = true]) {
    if (directory.isNotEmpty && !Directory(directory).existsSync()) {
      return Directory(directory).createSync(recursive: recursive);
    }
  }

  void createFile(RequestModel request) {
    final hasDirectory = request.directory.isNotEmpty;
    createDirectory(request.directory, request.isRecurcive);
    String fileName = request.fileName;
    if (request.isEntityName) fileName = _entityNameToFileName(fileName);
    fileName = '$fileName.${request.fileFormat}'.toLowerCase();
    final path = hasDirectory ? '${request.directory}/$fileName' : fileName;
    final imprts = _importsToString(request.imports, request.fileFormat);
    File(path).writeAsStringSync('$imprts${request.fileContent}');
  }

  String _importsToString(List<String> imprts, [String ext = '.dart']) {
    var buffer = StringBuffer();
    String formatImport(String path) {
      bool hasExtension = path.contains('.dart');
      if (hasExtension) return "import '$path';";
      return "import'$path.$ext';";
    }

    var formated = imprts.map(formatImport).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

// Helper Function:
  String _entityNameToFileName(String className) {
    var fileName = '';
    for (int index = 0, length = className.length; index < length; index++) {
      var character = className[index];
      final codeUnit = character.codeUnits.first;
      if (codeUnit <= 90 && index > 0) character = '_$character';
      fileName += character;
    }
    return fileName.toLowerCase();
  }
}
