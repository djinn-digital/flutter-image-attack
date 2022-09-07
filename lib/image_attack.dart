import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'dart:ui' as ui;

import 'package:image_attack/components/editor.dart';

class ImageAttack extends StatefulWidget {
  const ImageAttack({Key? key, required this.startFile}) : super(key: key);
  final File startFile;

  @override
  State<ImageAttack> createState() => _ImageAttackState();
}

class _ImageAttackState extends State<ImageAttack> {
  @override
  Widget build(BuildContext context) {
    Future<ui.Image> getImage() async {
      try {
        return FileImage(widget.startFile).image;
      } catch (e) {
        return Future.error("Failed to load image");
      }
    }

    return FutureBuilder<ui.Image>(
      future: getImage(),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black,
            ));
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null) {
              return const Text('Error: Image failed to load');
            } else {
              return ImageAttackEditor(initialImage: snapshot.data!);
            }
        }
      },
    );
  }
}
