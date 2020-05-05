import 'dart:io';
import 'package:path/path.dart';

mixin Pictures {
  static Directory docsDir;

  File picturesTempFile() {
    return File(picturesTempFileName());
  }

  String picturesTempFileName() {
    return join(docsDir.path, "pictures");
  }

  String picturesFileName(int id) {
    return join(docsDir.path, id.toString());
  }
}
