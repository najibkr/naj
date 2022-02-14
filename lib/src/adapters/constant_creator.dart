class ConstantCreator {
  final String keyword;
  final String dataType;
  final Stream<String> filesNames;
  final String constsDir;
  final String lang;
  const ConstantCreator({
    this.keyword = 'const',
    this.dataType = 'String',
    required this.filesNames,
    required this.constsDir,
    required this.lang,
  });

  Stream<String> generateConstants() {
    final filter = filesNames.map((file) {
      var name = _formatFileName(file).split('.').first;
      var fmt = file.split('.').last;
      if (lang == 'go') {
        String newDtype = dataType.toLowerCase();
        fmt = '${fmt[0].toUpperCase()}${fmt.substring(1).toLowerCase()}';
        return '$keyword $fmt$name $newDtype = Directory +"$file";\n';
      } else {
        return "$keyword $dataType $fmt$name = _directory +'$file';\n";
      }
    });
    return filter;
  }

  String _formatFileName(String file) {
    var withoutFmt = file.split('.').first;
    var list = withoutFmt.split('_').map((e) {
      return '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}';
    });
    return list.reduce((a, b) => a + b);
  }

  String genFileHeader() {
    if (lang == 'go') {
      const package = 'package main;\n\n';
      return '${package}const Directory string ="$constsDir/";\n\n';
    }
    return "const String _directory ='$constsDir';\n\n";
  }
}
