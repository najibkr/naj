import 'dart:io';

/// This will get the user input based on the assigned generic type
/// to user this,
///
/// Here is an example:
/// ```dart
/// String userName = getUserInput<String>('Enter your name');
/// // [User input]: John Doe
/// print('Welcome, $userName!');// Prints out Welcome, John Doe!
/// ```
///
///
///**`instruction`** is a helper message which guides the user what to do
/// by diplaying a message in the console when the program is running.
///
///**`allowEmpty`** is an optional parameter, which indicates whether
/// the parser should keep loopinguntil the user inputs something in
/// the console. If its is `false`, then, the user must input something.
T getInput<T>(String instruction, [bool allowEmpty = false]) {
  String stringInput = _getStringInput(instruction, allowEmpty);
  if (T == String) return stringInput as T;
  if (T == double) return _convertToDouble(stringInput) as T;
  if (T == int) return _convertToInt(stringInput) as T;
  if (T == bool) return _convertToBool(stringInput) as T;
  return stringInput as T;
}

String _getStringInput(String? instruction, bool allowEmpty) {
  String? input;
  do {
    stdout.write('$instruction: ');
    input = stdin.readLineSync()?.trim();
  } while ((input == null || input.isEmpty) && !allowEmpty);
  return input ?? '';
}

double _convertToDouble(String stringInput) {
  final doubleInput = double.tryParse(stringInput);
  return doubleInput ?? 0;
}

int _convertToInt(String stringInput) {
  final doubleInput = int.tryParse(stringInput);
  return doubleInput ?? 0;
}

bool? _convertToBool(String stringInput) {
  final lowered = stringInput.toLowerCase();
  if (lowered == 'y' ||
      lowered == 'yes' ||
      lowered == 't' ||
      lowered == 'true') {
    return true;
  } else {
    return false;
  }
}
