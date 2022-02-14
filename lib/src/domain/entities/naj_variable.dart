class NajVariable {
  final String name;
  final String dataType;
  final bool isImmutable;
  final bool isNullable;
  final bool isRequired;
  final bool isPrivate;
  final String defaultValue;

  const NajVariable({
    required this.name,
    required this.dataType,
    required this.isImmutable,
    required this.isNullable,
    required this.isRequired,
    required this.isPrivate,
    required this.defaultValue,
  });

  NajVariable copyWith({
    String? name,
    String? dataType,
    bool? isImmutable,
    bool? isNullable,
    bool? isRequired,
    bool? isPrivate,
    String? defaultValue,
  }) {
    return NajVariable(
      name: name ?? this.name,
      dataType: dataType ?? this.dataType,
      isImmutable: isImmutable ?? this.isImmutable,
      isNullable: isNullable ?? this.isNullable,
      isRequired: isRequired ?? this.isRequired,
      isPrivate: isPrivate ?? this.isPrivate,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }

  @override
  String toString() {
    final finalKey = isImmutable ? 'final ' : '';
    return '$finalKey$dataType$_nullSuffix $_privatePrefix$name;';
  }

  String get toStaticVariable {
    final constKey = isImmutable ? 'const ' : '';
    final type = '$dataType$_nullSuffix';
    final identifier = '$_privatePrefix$name';
    return 'static $constKey$type $identifier = $defaultValue;';
  }

  String get _nullSuffix => isNullable ? '?' : '';
  String get _privatePrefix => isPrivate ? '_' : '';
}
