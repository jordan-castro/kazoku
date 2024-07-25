import 'dart:async';

import 'package:flame/components.dart';
import 'package:kazoku/utils/convert_text_coords.dart';

class TileComponent extends SpriteComponent {
  final String coords;
  final String source;

  TileComponent({
    required this.coords,
    required this.source,
  });

  @override
  FutureOr<void> onLoad() async {
    final coordsV2 = convertTextCoords(coords);

    sprite = await Sprite.load(
      source,
      srcPosition: coordsV2[0],
      srcSize: coordsV2[1],
    );
  }
}
