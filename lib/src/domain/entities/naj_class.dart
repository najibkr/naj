import 'naj_constructor.dart';
import 'naj_copy_with.dart';
import 'naj_getter.dart';
import 'naj_json_serializer.dart';
import 'naj_setter.dart';
import 'naj_sub_class.dart';
import 'naj_variable.dart';

class NajClass {
  final String name;
  final bool isAbstract;
  final bool isImmutable;
  final List<NajVariable> instanceVariables;
  final List<NajConstructor> constructors;
  final NajJsonSerializer serializer;
  final List<NajSubclass> subClasses;
  final String fileDirectory;
  final List<String> imports;

  const NajClass({
    required this.name,
    required this.isAbstract,
    required this.isImmutable,
    required this.instanceVariables,
    required this.constructors,
    required this.serializer,
    required this.fileDirectory,
    required this.imports,
    required this.subClasses,
  });

  // String _formatImport(String fileImport) {
  //   if (fileImport.contains('.dart')) return "import '$fileImport';";
  //   return "import '$fileImport.dart';";
  // }

  // String get _formatedImports {
  //   var buffer = StringBuffer();
  //   var formated = imports.map(_formatImport).toList();
  //   formated.forEach(buffer.write);
  //   return buffer.toString();
  // }

  // Variables
  String get _formatedVariables {
    var buffer = StringBuffer();
    final formated = instanceVariables.map((e) => e.toString()).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedCopyWith {
    if (isAbstract || !isImmutable) return '';
    var copyWith = NajCopyWith(
      className: name,
      parameters: instanceVariables,
    );
    return copyWith.toString();
  }

  String get _formatedGetters {
    if (isAbstract) return '';
    var buffer = StringBuffer();
    var newSetter =
        instanceVariables.map((e) => NajGetter(e).toString()).toList();
    newSetter.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedSetters {
    if (isAbstract) return '';
    var buffer = StringBuffer();
    var newSetter =
        instanceVariables.map((e) => NajSetter(e).toString()).toList();
    newSetter.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedSerializer {
    if (isAbstract) return '';
    var serial = NajJsonSerializer(name, instanceVariables);
    return serial.toString();
  }

  String get _formattedConstructors {
    var buffer = StringBuffer();
    final formated = constructors.map((e) => e.toString()).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  @override
  String toString() {
    // final imprts = _formatedImports;
    final declaration = '${isAbstract ? 'abstract' : ''} class $name';
    final variables = _formatedVariables;
    final consts = _formattedConstructors;
    final copyWith = _formatedCopyWith;
    final getters = _formatedGetters;
    final setters = _formatedSetters;
    final gettersAndSetters = copyWith + getters + setters;
    final serializers = _formatedSerializer;
    return '$declaration{$variables$consts$gettersAndSetters$serializers}';
  }
}
