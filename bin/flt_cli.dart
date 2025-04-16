import 'package:flt_cli/flt_cli.dart' as flt_cli;

import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: flt_cli create page:<name>');
    return;
  }

  final command = arguments.first;

  if (command.startsWith('create') && arguments.length > 1) {
    final subCommand = arguments[1];

    if (subCommand.startsWith('page:')) {
      final name = subCommand.split(':')[1];

      createDataFolder(name);
      createDomainFolder(name);
    } else {
      print('Unknown subcommand: $subCommand');
    }
  } else {
    print('Invalid command.');
  }
}

void createDataFolder(String name) {
  final basePath = 'lib/app/data';
  final dirs = ['$basePath/app_url/$name', '$basePath/model/$name'];

  final packageName = getPackageName(); // 👈 Get package name dynamically
  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }

  // Create URL file with boilerplate
  final urlClassName = '${capitalize(name)}Url';
  writeFile('$basePath/app_url/$name/${name}_url.dart', '''
import 'package:$packageName/app/constants/strings.dart';

class $urlClassName {
  static String baseUrl = kBaseUrl;

  // Add endpoints here
  static String view = '\$baseUrl/view';
}
''');

  // Create empty model file
  writeFile('$basePath/model/$name/${name}_model.dart', '''
class ${capitalize(name)}Model {
  // Add fields and fromJson/toJson here
}
''');

  print('✅ Created data layer for: $name');
}

void createDomainFolder(String name) {
  final basePath = 'lib/app/domain';
  final dirs = ['$basePath/repositories/$name'];

  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }

  File('$basePath/repositories/$name/${name}_repository.dart').createSync();
  print('✅ Created GetX-style page: $name');
}

////////////
void writeFile(String path, String content) {
  final file = File(path);
  if (!file.existsSync()) {
    file.writeAsStringSync(content);
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
String getPackageName() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return 'your_app';

  final lines = pubspec.readAsLinesSync();
  for (final line in lines) {
    if (line.trim().startsWith('name:')) {
      return line.split(':')[1].trim();
    }
  }
  return 'your_app'; // fallback
}
