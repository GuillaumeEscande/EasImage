import 'package:easimage_lib/src/core/image_descriptor.dart';
import 'package:image/image.dart';

class Duplicate {
  final ImageDesciptor image1;
  final ImageDesciptor image2;
  final int score;

  Duplicate(this.image1, this.image2, this.score);
}

class PerceptualHash {
  late String hash;

  PerceptualHash(ImageDesciptor descriptor) {
    Image image = descriptor.image;
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
    hash = perceptualHash;
  }

  int compareTo(PerceptualHash other) {
    // Compter le nombre de bits correspondants
    int matchingBits = 0;
    for (int i = 0; i < hash.length; i++) {
      if (hash[i] == other.hash[i]) {
        matchingBits++;
      }
    }

    // Calculer la similarité (plage de 0 à 1)
    double similarity = matchingBits / hash.length;
    return (similarity * 100).round();
  }
}

class DuplicateFinder {
  final Map<ImageDesciptor, PerceptualHash> perceptualHashes = {};

  List<Duplicate> find(List<ImageDesciptor> collection) {
    final List<Duplicate> duplicates = [];

    for (int i = 0; i < collection.length; i++) {
      final ImageDesciptor descriptor1 = collection[i];

      for (int j = i + 1; j < collection.length; j++) {
        final ImageDesciptor descriptor2 = collection[j];
        final int score = compareImages(descriptor1, descriptor2);
        duplicates.add(Duplicate(descriptor1, descriptor2, score));
      }
    }

    return duplicates;
  }

  int compareImages(ImageDesciptor imagePath1, ImageDesciptor imagePath2) {
    PerceptualHash hash1 = getPerceptualHash(imagePath1);
    PerceptualHash hash2 = getPerceptualHash(imagePath2);
    return hash1.compareTo(hash2);
  }

  PerceptualHash getPerceptualHash(ImageDesciptor imageDescriptor) {
    if (perceptualHashes.containsKey(imageDescriptor)) {
      return perceptualHashes[imageDescriptor]!;
    } else {
      PerceptualHash perceptualHash = PerceptualHash(imageDescriptor);
      perceptualHashes[imageDescriptor] = perceptualHash;
      return perceptualHash;
    }
  }
}
