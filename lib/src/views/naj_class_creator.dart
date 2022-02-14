import '../adapters/file_generator.dart';
import '../domain/entities/naj_class.dart';
import '../domain/entities/naj_constructor.dart';
import '../domain/entities/naj_json_serializer.dart';
import '../domain/entities/naj_sub_class.dart';
import '../domain/entities/naj_variable.dart';
import '../usecases/naj_service.dart';
import '../usecases/request_model.dart';
import 'components/get_input.dart';
import 'components/render_welcome.dart';

class NajClassCreator {
  static const String _commands = '( create, modify, exit )';
  late NajClass najClass;
  final NajService _service = const NajService(FileGenerator());
  NajClassCreator.render() {
    renderWelcome('Naj Class Creator');
    while (true) {
      var initCommand = getInput('Enter a command $_commands');
      if (initCommand == 'exit') break;
      if (initCommand == 'create') _initClass();
    }
  }

  // Initialize Imports:
  List<String> get _initialzedImports {
    List<String> variables = [];
    for (int count = 1;; count++) {
      var color = col(count + 1);
      String import =
          getInput('\n${color}Enter DataType $count to import', true);
      if (import.contains('--')) break;
      variables.add(import);
    }
    return variables;
  }

  static String col([int increment = 1]) => '\u001B[1;3${increment + 1}m';
  // Initialized Variables:
  static List<NajVariable> _initVariables(bool isImmutable, String className) {
    bool? allNull;
    bool? allPriv;
    bool? allReq;
    bool agree = getInput('\nDo you want to setup defaults');
    if (agree) {
      allNull = getInput<bool>('\n${col(1)}Are all $className vars nullabe');
      allPriv = getInput<bool>('${col(2)}Are all $className vars private');
      allReq = getInput<bool>('${col(2)}Are all $className vars required');
    }
    List<NajVariable> variables = [];
    for (int count = 1;; count++) {
      String name = getInput('\n${col(1)}Enter variable $count name');
      if (name.contains('--')) break;
      String type = getInput('${col(2)}Enter $name data type');
      bool nullable = allNull ?? getInput('${col(3)}Is $name nullable');
      bool required = allReq ?? getInput('${col(4)}Is $name required');
      bool isPrivate = allPriv ?? getInput('${col(5)}Is $name private');
      String value = '';
      if (!required) value = getInput('${col(6)}Enter $name value', true);
      final newVariable = NajVariable(
        name: name,
        dataType: type,
        isImmutable: isImmutable,
        isNullable: nullable,
        isRequired: required,
        isPrivate: isPrivate,
        defaultValue: value,
      );
      variables.add(newVariable);
    }
    return variables;
  }

  // Initialize Constructors:
  List<NajConstructor> _initConstructors(
    String className,
    bool isConstant,
    List<NajVariable> parameters, [
    bool isInherited = false,
  ]) {
    List<NajConstructor> variables = [];
    for (int count = 1;; count++) {
      var constName = '$className\'s constructor';
      String name = getInput('\n${col(1)}Enter $constName $count name', true);
      if (name.contains('--')) break;
      var newConst = NajConstructor(
        name: name,
        className: className.split('<').first,
        isConstant: isConstant,
        parameters: parameters,
        isInherited: isInherited,
        isPrivate: getInput('${col(2)}Is $name constructor private'),
      );
      variables.add(newConst);
    }
    return variables;
  }

  // Initialize Subclasses:
  List<NajSubclass> _initSubclasses(
    bool isImmutable,
    List<NajVariable> variables,
  ) {
    List<NajSubclass> subclasses = [];
    for (int count = 1;; count++) {
      String name = getInput('\n${col(1)}Enter subclass $count name');
      if (name.contains('--')) break;
      var newSubclass = NajSubclass(
        name: name,
        isImmutable: isImmutable,
        variables: variables,
        superClass: getInput('${col(2)}Enter $name\'s super class name'),
        isAbstract: getInput('${col(3)}Is $name abstract'),
        constructors: _initConstructors(name, isImmutable, variables, true),
        imports: _initialzedImports,
      );
      subclasses.add(newSubclass);
    }
    return subclasses;
  }

  void _initClass() {
    String className = getInput('\n${col(1)}Enter new class name');
    bool isAbstract = getInput('${col(2)}Is $className abstract');
    bool isImmutable = getInput('${col(3)}Is $className immutable');
    final variables = _initVariables(isImmutable, className);
    najClass = NajClass(
      name: className,
      isAbstract: isAbstract,
      isImmutable: isImmutable,
      instanceVariables: variables,
      constructors: _initConstructors(className, isImmutable, variables),
      serializer: NajJsonSerializer(className.split('<').first, variables),
      subClasses: _initSubclasses(isImmutable, variables),
      fileDirectory: getInput('\n${col(2)}Enter $className directory', true),
      imports: _initialzedImports,
    );
    _createClass();
  }

  void _createClass() {
    final request = RequestModel(
      directory: najClass.fileDirectory,
      fileName: najClass.name.split('<').first,
      fileContent: najClass.toString(),
      isEntityName: true,
      imports: najClass.imports,
    );

    _service.createFile(request);
    for (var sub in najClass.subClasses) {
      final request = RequestModel(
        directory: najClass.fileDirectory,
        fileName: sub.name.split('<').first,
        fileContent: sub.toString(),
        isEntityName: true,
        imports: sub.imports,
      );
      _service.createFile(request);
    }
  }
}
