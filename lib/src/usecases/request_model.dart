class RequestModel {
  final String directory;
  final String fileName;
  final String fileContent;
  final bool isRecurcive;
  final bool isEntityName;
  final String fileFormat;
  final List<String> imports;

  const RequestModel({
    required this.directory,
    required this.fileName,
    required this.fileContent,
    this.isRecurcive = true,
    this.isEntityName = false,
    this.fileFormat = 'dart',
    required this.imports,
  });
}
