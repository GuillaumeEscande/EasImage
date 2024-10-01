import 'package:test/test.dart';

import 'package:easimage_lib/easimage_lib.dart';

void main() {
  test('Similarity same images', () {
    PerceptualHash hash1 = PerceptualHash(ImageDesciptor('test/resources/duplicate/duplicate_test/1_1.png'));

    int similarity = hash1.compareTo(hash1);

    expect(similarity, 100);
  });
  test('Similarity different images', () {
    PerceptualHash hash1 = PerceptualHash(ImageDesciptor('test/resources/duplicate/duplicate_test/1_1.png'));
    PerceptualHash hash2 = PerceptualHash(ImageDesciptor('test/resources/duplicate/duplicate_test/2_1.png'));

    int similarity1 = hash1.compareTo(hash2);
    expect(similarity1, greaterThanOrEqualTo(50));

    int similarity2 = hash2.compareTo(hash1);
    expect(similarity2, greaterThanOrEqualTo(50));

  });
  test('Similarity near images', () {
    DuplicateFinder finder = DuplicateFinder();
    int similarity = finder.compareImages(
        ImageDesciptor('test/resources/duplicate/duplicate_test/2_1.png'),
        ImageDesciptor('test/resources/duplicate/duplicate_test/2_2.png'));

    expect(similarity, greaterThanOrEqualTo(80));
  });
  test('find collection score', () async {
    DuplicateFinder finder = DuplicateFinder();
    List<Duplicate> duplicates = finder.find([
      ImageDesciptor('test/resources/duplicate/duplicate_test/1_1.png'),
      ImageDesciptor('test/resources/duplicate/duplicate_test/2_1.png'),
      ImageDesciptor('test/resources/duplicate/duplicate_test/2_2.png'),
      ImageDesciptor('test/resources/duplicate/duplicate_test/3.png')
    ]);
    expect(duplicates.length, 6);
  });
}
