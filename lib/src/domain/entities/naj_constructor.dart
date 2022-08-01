import 'naj_variable.dart';

class NajConstructor {
  final String name;
  final List<NajVariable> parameters;
  final bool isConstant;
  final bool isPrivate;
  final bool isInherited;
  final String className;

  const NajConstructor({
    required this.name,
    required this.parameters,
    required this.isConstant,
    required this.isPrivate,
    required this.isInherited,
    required this.className,
  });

  NajConstructor copyWith({
    String? name,
    List<NajVariable>? parameters,
    bool? isPrivate,
    bool? isConstant,
    bool? isInherited,
    String? className,
  }) {
    return NajConstructor(
      name: name ?? this.name,
      parameters: parameters ?? this.parameters,
      isConstant: isConstant ?? this.isConstant,
      isPrivate: isPrivate ?? this.isPrivate,
      isInherited: isInherited ?? this.isInherited,
      className: className ?? this.className,
    );
  }

  String _getNullPrefix(NajVariable parameter) {
    final notNull = parameter.isNullable == false;
    final isRequired = parameter.isRequired;
    final noDefaultValue = parameter.defaultValue.isEmpty;
    final addRequired = (notNull || isRequired) && noDefaultValue;
    return addRequired ? 'required ' : '';
  }

  String _formateDefaultValue(NajVariable param) {
    final hasDefValue = param.defaultValue.isNotEmpty;
    final defValue = hasDefValue ? '=${param.defaultValue}' : '';
    return '${param.name}$defValue';
  }

  String _formatParameter(NajVariable parameter) {
    final nullPrefix = _getNullPrefix(parameter);
    final keyValue = _formateDefaultValue(parameter);
    if (!parameter.isPrivate) return '$nullPrefix this.$keyValue,';
    final nullSuffix = parameter.isNullable ? '?' : '';
    return '$nullPrefix ${parameter.dataType}$nullSuffix $keyValue,';
  }

  String get _formatedParameters {
    var buffer = StringBuffer();
    final formated = parameters.map(_formatParameter).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  // Constructor Initializer List Functions:
  String _formatInitializer(NajVariable variable) {
    if (!variable.isPrivate) return '';
    return '_${variable.name} = ${variable.name},';
  }

  String get _formatInitializers {
    var buffer = StringBuffer();
    final formated = parameters.map(_formatInitializer).toList();
    formated.forEach(buffer.write);
    final bufferString = buffer.toString();
    return bufferString.substring(0, bufferString.length - 1);
  }

  String get _formatConstructorName {
    if (name.isEmpty) return isPrivate ? '._' : '';
    return isPrivate ? '._$name' : '.$name';
  }

  bool get _hasPrivateParameters {
    return parameters.any((element) => element.isPrivate);
  }

  String get _formatConstructor {
    var newName = _formatConstructorName;
    var formated = '$className$newName({$_formatedParameters})';
    if (_hasPrivateParameters) formated = '$formated:$_formatInitializers';
    if (isConstant) formated = 'const $formated';
    return '$formated;';
  }

  // Inherited Constructor:
  String _formatInheritedParameter(NajVariable variable) {
    final nullPrefix = _getNullPrefix(variable);
    final nullSuffix = variable.isNullable ? '?' : '';
    final value = _formateDefaultValue(variable);
    return '$nullPrefix${variable.dataType}$nullSuffix $value,';
  }

  String get _formatInheritedParameters {
    var buffer = StringBuffer();
    final formated = parameters.map(_formatInheritedParameter).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatSuperVariables {
    var buffer = StringBuffer();
    for (var param in parameters) {
      buffer.write('${param.name}: ${param.name},');
    }
    return buffer.toString();
  }

  String get _formatInheritedConstructor {
    var newName = _formatConstructorName;
    var formated = '$className$newName({$_formatInheritedParameters})';
    formated = '$formated : super($_formatSuperVariables)';
    if (isConstant) formated = 'const $formated';
    return '$formated;';
  }

  @override
  String toString() {
    final con = isInherited ? _formatInheritedConstructor : _formatConstructor;
    final bool isInit = name.contains('init');
    if (isInit) return con.replaceAll('required', '');
    return con;
  }

}
