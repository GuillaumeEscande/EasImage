import 'dart:io';
import 'package:image/image.dart';

// Fonction pour générer une empreinte digitale perceptive à partir d'une image
String generatePerceptualHash(File imageFile) {
  // Lire l'image
  Image image = decodeImage(imageFile.readAsBytesSync())!;

  // Redimensionner l'image (facultatif)
  image = copyResize(image, width: 32, height: 32);

  // Convertir l'image en nuances de gris
  image = grayscale(image);

  // Appliquer un filtre flou gaussien
  image = gaussianBlur(image, radius: 3);

  // Calculer la moyenne des valeurs de pixels
  num averageColor = 0;
  for (Pixel pixel in image) {
    averageColor += pixel.luminance;
  }
  averageColor ~/= image.width * image.height;

  // Générer l'empreinte digitale binaire
  String perceptualHash = '';
  for (Pixel pixel in image) {
    perceptualHash += (pixel.luminance > averageColor) ? '1' : '0';
  }

  // Renvoyer l'empreinte digitale
  return perceptualHash;
}

// Fonction pour comparer deux empreintes digitales et calculer la similarité
int comparePerceptualHashes(String hash1, String hash2) {
  // Compter le nombre de bits correspondants
  int matchingBits = 0;
  for (int i = 0; i < hash1.length; i++) {
    if (hash1[i] == hash2[i]) {
      matchingBits++;
    }
  }

  // Calculer la similarité (plage de 0 à 1)
  double similarity = matchingBits / hash1.length;
  return (similarity * 100).round();
}

class Duplicate {
  final String image1;
  final String image2;
  final int score;

  Duplicate(this.image1, this.image2, this.score);
}

int compareImages(String imagePath1, String imagePath2) {
  String hash1 = generatePerceptualHash(File(imagePath1));
  String hash2 = generatePerceptualHash(File(imagePath2));
  return comparePerceptualHashes(hash1, hash2);
}

List<Duplicate> findDuplicate(List<String> collection) {
  final List<Duplicate> duplicates = [];

  for (int i = 0; i < collection.length; i++) {
    final String imagePath1 = collection[i];

    for (int j = i + 1; j < collection.length; j++) {
      final String imagePath2 = collection[j];
      final int score = compareImages(imagePath1, imagePath2);
      duplicates.add(Duplicate(imagePath1, imagePath2, score));
    }
  }

  return duplicates;
}
