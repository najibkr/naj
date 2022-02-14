import 'dart:io';

class DirectoryReader {
  final String path;
  DirectoryReader(this.path);

  Stream<String> readFileNames({bool readSubDirs = false}) {
    final dir = Directory(path);
    final dirs = dir.list(recursive: readSubDirs).asBroadcastStream();
    final filter = dirs.map((event) {
      if (event is File) return event.path.split('/').last;
      return '';
    });
    return filter.where((event) => event != '');
  }

  Stream<Uri> readUris() {
    final dir = Directory(path);
    final dirs = dir.list(recursive: true);
    return dirs.map((each) => each.uri);
  }

  Stream<String> readPath() {
    final dir = Directory(path);
    final dirs = dir.list(recursive: true);
    return dirs.map((each) => each.path);
  }
}
