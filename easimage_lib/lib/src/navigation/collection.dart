import 'dart:io';

// Méthode pour détecter les images dans un répertoire et renvoyer une liste
Future<List<String>> detectImages(String directoryPath) {
  return Directory(directoryPath)
      .list(recursive: true)
      .where((entity) => entity is File)
      .where((entity) => ['jpg', 'jpeg', 'png', 'bmp', 'gif']
          .contains(entity.path.split('.').last.toLowerCase()))
      .where((entity) => entity.statSync().size > 64)
      .map((entity) => entity.path)
      .toList();
}
