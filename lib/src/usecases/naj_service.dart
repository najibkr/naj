import '../adapters/file_generator.dart';
import 'request_model.dart';

class NajService {
  final FileGenerator _generator;
  const NajService(FileGenerator generator) : _generator = generator;

  void createFile(RequestModel request) {
    return _generator.createFile(request);
  }
}
