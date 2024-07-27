import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kazoku/utils/convert_text_coords.dart';

/// This is for objects.
class TextureImageButton extends StatelessWidget {
  final String? assetSource;
  final Uint8List? bytes;
  final double height;
  final double width;
  final BoxFit? fit;
  final Function() onPressed;

  const TextureImageButton({
    super.key,
    this.assetSource,
    required this.height,
    required this.width,
    this.fit,
    required this.onPressed,
    this.bytes,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: assetSource != null
          ? Image.asset(
              "assets/images/$assetSource",
              height: height,
              width: width,
              fit: fit,
            )
          : Image.memory(
              bytes!,
              height: height,
              width: width,
              fit: fit,
            ),
    );
  }
}

/// This is for tiles.
class TileImageButton extends StatelessWidget {
  final String source;
  final double height;
  final double width;
  final String coords;
  final BoxFit? fit;
  final Function() onPressed;

  const TileImageButton({
    super.key,
    required this.source,
    required this.height,
    required this.width,
    required this.coords,
    this.fit,
    required this.onPressed,
  });

  Future<img.Image> _loadAndCropImage() async {
    // Convert the text coordinates
    final vectors = convertTextCoords(coords);
    final tilePosition = vectors[0];
    final tileSize = vectors[1];

    // Load the sprite sheet
    final ByteData data = await rootBundle.load('assets/images/$source');
    final Uint8List bytes = data.buffer.asUint8List();
    final img.Image spriteSheet = img.decodeImage(bytes)!;

    // Crop the specific tile
    final img.Image croppedImage = img.copyCrop(
      spriteSheet,
      x: tilePosition.x.toInt(),
      y: tilePosition.y.toInt(),
      width: tileSize.x.toInt(),
      height: tileSize.y.toInt(),
    );

    return croppedImage;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<img.Image>(
      future: _loadAndCropImage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: height,
            width: width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return TextureImageButton(
          bytes: Uint8List.fromList(img.encodePng(snapshot.data!)),
          height: height,
          width: width,
          onPressed: onPressed,
          fit: fit,
        );
      },
    );
  }
}
