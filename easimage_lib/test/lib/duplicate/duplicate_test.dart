import 'dart:io';

import 'package:easimage_lib/src/duplicate/duplicate.dart';
import 'package:test/test.dart';

void main() {
  test('Similarity same images', () {
    String hash1 = generatePerceptualHash(
        File('test/resources/duplicate/duplicate_test/1_1.png'));

    int similarity = comparePerceptualHashes(hash1, hash1);

    expect(similarity, 100);
  });
  test('Similarity different images', () {
    String hash1 = generatePerceptualHash(
        File('test/resources/duplicate/duplicate_test/1_1.png'));
    String hash2 = generatePerceptualHash(
        File('test/resources/duplicate/duplicate_test/2_1.png'));

    int similarity = comparePerceptualHashes(hash1, hash2);

    expect(similarity, greaterThanOrEqualTo(50));
  });
  test('Similarity near images', () {
    int similarity = compareImages(
        'test/resources/duplicate/duplicate_test/2_1.png',
        'test/resources/duplicate/duplicate_test/2_2.png');

    expect(similarity, greaterThanOrEqualTo(80));
  });
  test('find collection score', () async {
    List<Duplicate> duplicates = findDuplicate([
      'test/resources/duplicate/duplicate_test/1_1.png',
      'test/resources/duplicate/duplicate_test/2_1.png',
      'test/resources/duplicate/duplicate_test/2_2.png',
      'test/resources/duplicate/duplicate_test/3.png'
    ]);
    expect(duplicates.length, 6);
  });
}
