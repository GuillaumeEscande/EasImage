import 'dart:io';

import 'package:image/image.dart';

class ImageDesciptor {
  final String path;
  late final Image image;

  ImageDesciptor(this.path) {
    image = decodeImage(File(path).readAsBytesSync())!;
  }

}
