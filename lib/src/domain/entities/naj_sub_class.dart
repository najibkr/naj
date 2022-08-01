import 'naj_constructor.dart';
import 'naj_copy_with.dart';
import 'naj_getter.dart';
import 'naj_json_serializer.dart';
import 'naj_setter.dart';
import 'naj_variable.dart';

class NajSubclass {
  final String superClass;
  final String name;
  final bool isAbstract;
  final bool isImmutable;
  final List<NajVariable> variables;
  final List<NajConstructor> constructors;
  final List<String> imports;
  const NajSubclass({
    required this.superClass,
    required this.name,
    required this.isAbstract,
    required this.isImmutable,
    required this.variables,
    required this.constructors,
    required this.imports,
  });

  String _formatConstructor(NajConstructor constr) {
    final newConst = constr.copyWith(
      isInherited: true,
      className: name,
      parameters: variables,
    );
    return newConst.toString();
  }

  String get _formatedConstructors {
    var buffer = StringBuffer();
    final formated = constructors.map(_formatConstructor).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedGetters {
    if (isAbstract) return '';
    var buffer = StringBuffer();
    var newSetter = variables.map((e) => NajGetter(e).toString()).toList();
    newSetter.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedSetters {
    if (isAbstract) return '';
    var buffer = StringBuffer();
    var newSetter = variables.map((e) => NajSetter(e).toString()).toList();
    newSetter.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedCopyWith {
    if (isAbstract || !isImmutable) return '';
    var copy = NajCopyWith(className: name, parameters: variables);
    return copy.toString();
  }

  String get _formatedSerializer {
    if (isAbstract) return '';
    var serial = NajJsonSerializer(name, variables);
    return serial.toString();
  }

  @override
  String toString() {
    // final imprts = _formatedImports;
    final abstractKey = isAbstract ? 'abstract ' : '';
    final declaration = '${abstractKey}class $name extends $superClass';
    final consts = _formatedConstructors;
    final copy = _formatedCopyWith;
    final getters = _formatedGetters;
    final setters = _formatedSetters;
    final serializer = _formatedSerializer;
    return '$declaration {$consts $copy $getters $setters $serializer}';
  }
}
