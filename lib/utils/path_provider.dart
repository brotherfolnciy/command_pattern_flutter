import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Path {
  Future<String> getPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory directory = await Directory(appDocDirectory.path + '/' + 'dir')
        .create(recursive: true);
    return directory.path;
  }
}
