import 'naj_variable.dart';

class NajGetter {
  final NajVariable variable;
  const NajGetter(this.variable);

  NajGetter copyWith(NajVariable? variable) {
    return NajGetter(variable ?? this.variable);
  }

  @override
  String toString() {
    if (!variable.isPrivate || variable.isImmutable) return '';
    final name = variable.name;
    var nameCaps = name[0].toUpperCase() + name.substring(1);
    final nullSuffix = variable.isNullable ? '?' : '';
    final dataType = variable.dataType;
    return '$dataType$nullSuffix get get$nameCaps => _$name;';
  }
}
