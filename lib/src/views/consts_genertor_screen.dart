// ignore_for_file: avoid_print

import '../adapters/constant_creator.dart';
import '../adapters/consts_file_generator.dart';
import '../adapters/directory_reader.dart';
import 'components/get_input.dart';
import 'components/render_welcome.dart';

class ConstsGeneratorScreen {
  static void start() {
    renderWelcome('Assets Constants Generator');
    final String filesPath = getInput('Enter assets folder');
    final String genPath = getInput('Enter consts file directory');
    final String? genFileName = getInput('Enter file name with go/dart format');
    final String? constsDir = getInput('Enter consts file directory variable');
    print('-------------------------------------------');
    print('Reading Files from: $filesPath');
    print('Will The File At: $genPath');
    print('Generated File name will be: $genFileName');
    print('Constants Directory Header: $constsDir');
    print('-------------------------------------------');
    print(genFileName!.split('.').last);
    var fileGenerator = ConstsFileGenerator(
      path: genPath,
      filename: genFileName,
      constCreator: ConstantCreator(
        keyword: 'const',
        dataType: 'String',
        filesNames: DirectoryReader(filesPath).readFileNames(),
        constsDir: '$constsDir',
        lang: genFileName.split('.').last,
      ),
    );
    fileGenerator.generateFile();
  }
}
