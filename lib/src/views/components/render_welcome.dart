import 'dart:io';

void renderWelcome(String moduleName) {
  stdout.write('''

\u001B[1;39m-----------------------------------------
   \u001B[1;36mWelcome to $moduleName
\u001B[1;39m-----------------------------------------
''');
}
