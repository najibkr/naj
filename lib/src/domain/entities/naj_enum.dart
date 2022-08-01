class NajEnum {
  final String name;
  final List<String> fields;
  const NajEnum({required this.name, required this.fields});

  NajEnum copyWith({String? name, List<String>? fields}) {
    return NajEnum(name: name ?? this.name, fields: fields ?? this.fields);
  }

  String get _formatFields {
    var buffer = StringBuffer();
    var formattedField = fields.map((e) => '$e, ').toList();
    formattedField.forEach(buffer.write);
    return buffer.toString();
  }

  String get _formatedExtension {
    final declaration = 'extension ${name}Parser on $name';
    // final value = "String get value => toString().split('.').last;";
    final fromStr = '''
    static $name? fromName(String? name) {
    if (name == null) return null;
    try { return $name.values.firstWhere((e) => e.name == name);} 
    catch (e) {return null;}}
    ''';
    return '$declaration {$fromStr}';
  }

  @override
  String toString() {
    return 'enum $name {$_formatFields} $_formatedExtension';
  }
}
