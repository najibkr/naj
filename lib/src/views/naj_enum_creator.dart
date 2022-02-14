import '../adapters/file_generator.dart';
import '../domain/entities/naj_enum.dart';
import '../usecases/naj_service.dart';
import '../usecases/request_model.dart';
import 'components/get_input.dart';

class NajEnumCreator {
  // Class Variables;
  static const String exitCmd = '\u001B[1;31mexit';
  static const String cmds = '\u001B[1;33mcreate enum\u001B[1;34m, modify enum';

  final NajService _service = const NajService(FileGenerator());
  late NajEnum najEnum;
  late String directory;
  NajEnumCreator.render() {
    while (true) {
      String cmd = getInput('\u001B[1;32mEnter a command $cmds, $exitCmd)');
      if (cmd.contains('exit')) break;
      if (cmd.contains('create')) {
        _initializeNajEnum;
        directory = getInput('\u001B[1;35mEnter file directory', true);
        _createEnum();
      }
    }
  }

  void get _initializeNajEnum {
    String enteredName = getInput('\u001B[1;33mEnter enum identifier');
    najEnum = NajEnum(name: enteredName, fields: _initializeEnumFields);
  }

  List<String> get _initializeEnumFields {
    List<String> fields = [];
    for (int count = 1;; count++) {
      String fieldName = getInput('\u001B[1;33mEnter enum field $count name');
      if (fieldName.contains('--') || fieldName.contains('--done')) break;
      fields.add(fieldName);
    }
    return fields;
  }

  void _createEnum() {
    final request = RequestModel(
      directory: directory,
      fileName: najEnum.name,
      fileContent: najEnum.toString(),
      isEntityName: true,
      imports: [],
    );
    _service.createFile(request);
  }
}
