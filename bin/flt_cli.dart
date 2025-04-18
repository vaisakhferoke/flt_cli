// import 'package:flt_cli/flt_cli.dart' as flt_cli;

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
      // createGetView(name);
      createPage(name);
    } else {
      print('Unknown subcommand: $subCommand');
    }
  } else {
    print('Invalid command.');
  }
}

void createPage(String fullPath) async {
  bool isParentPath = false;
  String parentFolder = '';
  final parts = fullPath.split('/');
  if (parts.length > 1) {
    isParentPath = true;
    parentFolder = parts.sublist(0, parts.length - 1).join('/');
  }

  final pageName = parts.last;

  createDataFolder(isParentPath ? parentFolder : '', pageName);
  createDomainFolder(isParentPath ? parentFolder : '', pageName);

  print('✅ Successfully created page: $pageName under "$parentFolder"');
}

// void createGetView(String name) async {
//   final command = 'get';
//   final arguments = ['create', 'page:$name'];

//   try {
//     // Execute the `get` CLI command
//     final result = await Process.run(command, arguments);

//     if (result.exitCode == 0) {
//       print('✅ Successfully executed: get create page:$name');
//       print(result.stdout); // Display success output
//     } else {
//       print('❌ Error executing command: get create page:$name');
//       print(result.stderr); // Display error output
//     }
//   } catch (e) {
//     print('❌ Exception occurred while executing: $e');
//   }
// }

void createDataFolder(String parentFolder, String name) {
  print('✅ CPath: $parentFolder');

  final basePathAppUrl =
      parentFolder.isEmpty
          ? 'lib/app/data/app_url'
          : 'lib/app/data/app_url/$parentFolder';
  final basePathAppModel =
      parentFolder.isEmpty
          ? 'lib/app/data/model'
          : 'lib/app/data/model/$parentFolder';
  //final dirs = [basePathAppUrl, basePathAppModel];

  final packageName = getPackageName(); // 👈 Get package name dynamically
  // // parent section
  // if (parentFolder.isNotEmpty) {
  //   for (final dir in dirs) {
  //     Directory(dir).createSync(recursive: true);
  //   }
  // }

  final dirs1 = ['$basePathAppUrl/$name', '$basePathAppModel/$name'];

  for (final dir in dirs1) {
    Directory(dir).createSync(recursive: true);
  }

  File('$basePathAppUrl/$name/${name}_url.dart').createSync();

  // Create URL file with boilerplate
  final urlClassName = '${capitalize(name)}Url';
  writeFile('$basePathAppUrl/$name/${name}_url.dart', '''
import 'package:$packageName/app/constants/strings.dart';

class $urlClassName {
  static String baseUrl = kBaseUrl;

  // Add endpoints here
  static String view = '\$baseUrl/view';
}
''');
  File('$basePathAppModel/$name/${name}_model.dart').createSync();
  // Create empty model file
  writeFile('$basePathAppModel/$name/${name}_model.dart', '''
class ${capitalize(name)}Model {
  // Add fields and fromJson/toJson here
}
''');

  print('✅ Created data layer for: $name');
}

void createDomainFolder(String parentFolder, String name) {
  final packageName = getPackageName(); // 👈 Get package name dynamically
  final basePathUrls =
      parentFolder.isEmpty
          ? 'lib/app/domain/repositories'
          : 'lib/app/domain/repositories/$parentFolder';

  Directory("$basePathUrls/$name").createSync(recursive: true);

  File('$basePathUrls/$name/${name}_repository.dart').createSync();
  print('✅ Created GetX-style page: $name');

  // Create URL file with boilerplate
  final urlClassName = '${capitalize(name)}Repository';
  writeFile('$basePathUrls/$name/${name}_repository.dart', '''
  import 'package:$packageName/app/constants/strings.dart';
  import 'package:dartz/dartz.dart';
  import 'package:$packageName/app/core/failure/failure.dart';
  import 'package:$packageName/app/data/network/network_api_services.dart';
  import 'package:$packageName/app/data/model/api_model.dart';

  class $urlClassName extends NetworkApiServices {
    static String baseUrl = kBaseUrl;

    // Add endpoints here
    static String view = '\$baseUrl/view';
  }
  ''');
}

////////////
void writeFile(String path, String content) {
  try {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(content);
    print('✅ Successfully wrote to file: $path');
  } catch (e) {
    print('❌ Error writing to file $path: $e');
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
