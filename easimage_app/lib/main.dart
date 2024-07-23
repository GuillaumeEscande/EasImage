import 'package:flutter/material.dart';

import 'app/gallery/gallery_screen.dart';

void main() {
  runApp(const EasImage());
}

class EasImage extends StatelessWidget {
  const EasImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EasImage',
      themeMode: ThemeMode.light,
      home: GalleryScreen(),
    );
  }
}
