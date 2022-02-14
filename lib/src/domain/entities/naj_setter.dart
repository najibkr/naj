import 'naj_variable.dart';

class NajSetter {
  final NajVariable variable;
  const NajSetter(this.variable);
  NajSetter copyWith(NajVariable? variable) {
    return NajSetter(variable ?? this.variable);
  }

  @override
  String toString() {
    if (!variable.isPrivate || variable.isImmutable) return '';
    final name = variable.name;
    var nameCaps = name[0].toUpperCase() + name.substring(1);
    final nullSuffix = variable.isNullable ? '?' : '';
    final parameter = '${variable.dataType}$nullSuffix new$nameCaps';
    return 'set set$nameCaps($parameter)=> _$name = new$nameCaps;';
  }
}
