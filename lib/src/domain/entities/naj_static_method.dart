class NajStaticMethod with BuitinStaticMethods {
  final String methodName;
  final String definition;
  const NajStaticMethod({this.methodName = '', this.definition = ''});

  List<NajStaticMethod> get buitlinMethods => [
        NajStaticMethod(
          methodName: '_toInt',
          definition: toIntFunction,
        ),
        NajStaticMethod(
          methodName: '_toDouble',
          definition: toDoubleFunction,
        ),
        NajStaticMethod(
          methodName: '_toDateTime',
          definition: toDateTimeFunction,
        ),
        NajStaticMethod(
          methodName: '_toListOfString',
          definition: toListOfStringFunction,
        ),
        NajStaticMethod(
          methodName: 'toListOfIntFunction',
          definition: toListOfIntFunction,
        ),
        NajStaticMethod(
          methodName: '_toListOfInt',
          definition: toListOfIntFunction,
        ),
        NajStaticMethod(
          methodName: '_toListOfDouble',
          definition: toListOfDoubleFunction,
        ),
        NajStaticMethod(
          methodName: '_toListOfDateTime',
          definition: toListOfDateTimeFunction,
        ),
      ];
}

mixin BuitinStaticMethods {
  String parseStatusMethods(String fromJson) {
    var buffer = StringBuffer();
    final methods = getters.map((e) => fromJson.contains(e) ? e : ' ').toList();
    methods.forEach(buffer.write);
    return buffer.toString();
  }

  List<String> get getters {
    var list = <String>[];
    list.add(toIntFunction);
    list.add(toDoubleFunction);
    list.add(toDateTimeFunction);
    list.add(toListOfStringFunction);
    list.add(toListOfIntFunction);
    list.add(toListOfDoubleFunction);
    return list;
  }

  String get toIntFunction {
    const declaration = 'static int _toInt(dynamic data)';
    const zero = 'if (data == null) return 0;';
    const strParse = 'if (data is String) return int.tryParse(data) ?? 0;';
    const asNum = 'num newData = data as num;';
    const intReturn = 'return newData.toInt();';
    return '$declaration{$zero$strParse$asNum$intReturn}';
  }

  String get toDoubleFunction {
    const declaration = 'static double _toDouble(dynamic data)';
    const zero = 'if (data == null) return 0;';
    const strParse = 'if (data is String) return double.tryParse(data) ?? 0;';
    const asNum = 'num newData = data as num;';
    const intReturn = 'return newData.toDouble();';
    return '$declaration{$zero$strParse$asNum$intReturn}';
  }

  String get toDateTimeFunction {
    const parameters = 'dynamic data, [bool isFirebase = true]';
    const declaration = 'static DateTime? _toDateTime($parameters)';
    const nullReturn = 'if (data == null) return null;';
    const parseFirestore = 'if (isFirebase) return data.toDate();';
    const stringParse = 'return DateTime.tryParse(data.toString());';
    return '$declaration {$nullReturn$parseFirestore$stringParse}';
  }

  String get toListOfStringFunction {
    const declaration = 'static List<String> _toListOfString(List? list)';
    const emptyList = 'if (list == null || list.isEmpty) return [];';
    const mappedList = 'return list.map((e) => e.toString()).toList();';
    return '$declaration {$emptyList$mappedList}';
  }

  String get toListOfIntFunction {
    const declaration = 'static List<int> _toListOfInt(List? list)';
    const emptyList = 'if (list == null || list.isEmpty) return [];';
    const tryParse = 'int.tryParse(e.toString()) ?? 0';
    const mapped = 'return list.map((e) => $tryParse).toList();';
    return '$declaration {$emptyList$mapped}';
  }

  String get toListOfDoubleFunction {
    const declaration = 'static List<double> _toListOfDouble(List? list)';
    const emptyList = 'if (list == null || list.isEmpty) return [];';
    const tryParse = 'double.tryParse(e.toString()) ?? 0';
    const mapped = 'return list.map((e) => $tryParse).toList();';
    return '$declaration {$emptyList$mapped}';
  }

  String get toListOfDateTimeFunction {
    const parameters = 'List? list, [bool isFirebase = true]';
    const declaration = 'static List<DateTime> _toListOfDateTime($parameters)';
    const emptyList = 'if (list == null || list.isEmpty) return [];';
    const parseFS = 'if (isFirebase) return e.toDate()as DateTime;';
    const tryParse = 'DateTime.tryParse(e.toString()) ?? DateTime.now();';
    const mapBody = '{$parseFS return $tryParse}';
    const mapped = 'return list.map((e) $mapBody).toList();';
    return '$declaration {$emptyList$mapped}';
  }

  String toListOfDataTypeFunction(String dataType) {
    final declaration = 'static List<$dataType> listFromJson(List? list)';
    const emptyList = 'if(list == null || list.isEmpty) return [];';
    final mappedList = 'list.map((e)=> $dataType.fromJson(e)).toList();';
    return '$declaration {$emptyList return $mappedList}';
  }
}
