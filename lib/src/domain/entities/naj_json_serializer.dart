import 'naj_static_method.dart';
import 'naj_variable.dart';

class NajJsonSerializer extends NajStaticMethod {
  final String className;
  final List<NajVariable> variables;
  const NajJsonSerializer(this.className, this.variables) : super();

  NajJsonSerializer copyWith({
    String? className,
    List<NajVariable>? variables,
  }) {
    return NajJsonSerializer(
      className ?? this.className,
      variables ?? this.variables,
    );
  }

  bool _isPrimitive(NajVariable variable) {
    final isBool = variable.dataType.contains('bool');
    final isInt = variable.dataType.contains('int');
    final isDouble = variable.dataType.contains('double');
    final isString = variable.dataType.contains('String');
    if (isBool || isInt || isDouble || isString) return true;
    return false;
  }

  bool _isDateTime(NajVariable variable) {
    return variable.dataType.contains('DateTime');
  }

  bool _isList(NajVariable variable) {
    return variable.dataType.contains('List');
  }

  // To Json Related:
  String _formatToJsonKey(NajVariable variable) {
    return "'${variable.name}'";
  }

  String _formatToJsonValue(NajVariable variable) {
    final nullPrefix = variable.isPrivate ? '_' : '';
    final isNullable = variable.isNullable && !_isPrimitive(variable);
    final nullSuffix = isNullable ? '?' : '';
    return '$nullPrefix${variable.name}$nullSuffix';
  }

  String _formatToJsonKeyValue(NajVariable variable) {
    final key = _formatToJsonKey(variable);
    var value = _formatToJsonValue(variable);
    if (_isPrimitive(variable)) return '$key :$value,';
    value = '${_formatToJsonValue(variable)}.map((e)=> e.toString()).toList()';
    if (_isList(variable) && _isDateTime(variable)) return '$key :$value,';
    value = '${_formatToJsonValue(variable)}.toString()';
    if (_isDateTime(variable)) return '$key :$value,';
    value = '${_formatToJsonValue(variable)}.map((e)=> e.toJson()).toList()';
    if (_isList(variable)) return '$key :$value,';
    value = '${_formatToJsonValue(variable)}.toJson()';
    return '$key :$value,';
  }

  String get _formatedToJsonKeysValues {
    var buffer = StringBuffer();
    final formated = variables.map(_formatToJsonKeyValue).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedToJson {
    const declaration = 'Map<String, dynamic> toJson()';
    final json = 'var json = <String, dynamic> {$_formatedToJsonKeysValues};';
    const removeNull = 'json.removeWhere((key, value)=> value == null);';
    return '$declaration {$json$removeNull return json;}';
  }

  // From Json:
  String _filterDataType(NajVariable variable) {
    var iden = variable.dataType.replaceAll('List', '');
    iden = iden.replaceAll('<', '').replaceAll('>', '');
    return iden;
  }

  String _formatFromJsonVariable(NajVariable variable) {
    final type = variable.dataType;
    // Key and Value
    final key = variable.name;
    final value = "json['${variable.name}']";
    if (type == 'List<String>') return '$key: _toListOfString($value),';
    if (type == 'List<int>') return '$key: _toListOfInt($value),';
    if (type == 'List<double>') return '$key: _toListOfDouble($value),';
    if (type == 'List<DateTime>') return '$key: _toListOfDateTime($value),';
    if (type == 'int') return '$key: _toInt($value),';
    if (type == 'double') return '$key: _toDouble($value),';
    if (type == 'DateTime') return '$key: _toDateTime($value),';
    if (type == 'String') return '$key: $value,';
    final listNotPrime = !_isPrimitive(variable) && _isList(variable);
    final filtered = _filterDataType(variable);
    if (listNotPrime) return '$key: $filtered.listFromJson($value),';
    final noteListOrPrime = !_isPrimitive(variable) && !_isList(variable);
    if (noteListOrPrime) return '$key: $type.fromJson($value),';
    return '$key: $value,';
  }

  String get _formattedFromJsonVariables {
    var buffer = StringBuffer();
    var formated = variables.map(_formatFromJsonVariable).toList();
    formated.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedFromJson {
    final filtered = className.split('<').first;
    final declare = 'factory $filtered.fromJson(Map<String,dynamic>? json)';
    final empty = 'if(json == null)return $className.init();';
    final variables = _formattedFromJsonVariables;
    return '$declare{$empty return $className($variables); }';
  }

  @override
  String toString() {
    final finalized = '$_formatedToJson $_formatedFromJson';
    var buffer = StringBuffer();
    var filteredMethods = buitlinMethods.map((method) {
      if (finalized.contains(method.methodName)) return method.definition;
      return '';
    }).toList();
    filteredMethods.forEach(buffer.write);
    buffer.write(toListOfDataTypeFunction(className));
    return '$finalized ${buffer.toString()}';
  }
}
