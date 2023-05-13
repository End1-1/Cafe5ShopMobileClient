import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Dir {
  static Directory findRoot(FileSystemEntity entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return findRoot(parent);
  }

  static Future<String> appPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/Magnit';
  }

  static Future<String> dataFile() async {
    final path = await appPath();
    return '$path/magnitdata.json';
  }
}