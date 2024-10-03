import 'dart:io';
import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  final String imagePath;

  const BackgroundImageWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);

    if (file.existsSync()) {
      // If the file exists, display the image
      return Image.file(file, fit: BoxFit.cover);
    } else {
      // If the file does not exist, display a default or placeholder image
      return Container(
        color: Colors.grey,
        child: Center(child: Text('No Image Available')),
      );
    }
  }
}
