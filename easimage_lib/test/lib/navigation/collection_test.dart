import 'package:easimage_lib/src/navigation/collection.dart';
import 'package:test/test.dart';

void main() {
  test('Find all images file', () {
    detectImages('test/resources/navigation/navigation_test').then(
      (images) {
        expect(images.length, 3);
      },
    );
  });
}
