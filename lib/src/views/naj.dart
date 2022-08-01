import 'components/get_input.dart';
import 'consts_genertor_screen.dart';
import 'naj_class_creator.dart';
import 'naj_enum_creator.dart';

class Naj {
  Naj.render() {
    while (true) {
      String cmd = getInput('Enter a command (class, enum, consts, exit)');
      if (cmd == 'exit') break;
      if (cmd == 'class') {
        NajClassCreator.render();
      } else if (cmd == 'enum') {
        NajEnumCreator.render();
      } else if (cmd == 'consts') {
        ConstsGeneratorScreen.start();
      }
    }
  }
}
