import 'naj_variable.dart';

class NajCopyWith {
  final String className;
  final List<NajVariable> parameters;
  const NajCopyWith({required this.className, required this.parameters});

  NajCopyWith copyWith({String? className, List<NajVariable>? parameters}) {
    return NajCopyWith(
      className: className ?? this.className,
      parameters: parameters ?? this.parameters,
    );
  }

  String _formatParameter(NajVariable variable) {
    return '${variable.dataType}? ${variable.name},';
  }

  String get _formatedParameters {
    var buffer = StringBuffer();
    var formated = parameters.map(_formatParameter).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  String _formatInitializer(NajVariable variable) {
    final name = variable.name;
    final instanceVariabe = variable.isPrivate ? '_$name' : 'this.$name';
    return '$name: $name ?? $instanceVariabe,';
  }

  String get _formatedInitializers {
    var buffer = StringBuffer();
    var formated = parameters.map(_formatInitializer).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  @override
  String toString() {
    final declaration = '$className copyWith({$_formatedParameters})';
    final bloc = '{return $className($_formatedInitializers);}';
    return '$declaration$bloc';
  }
}
