import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:kazoku/components/character/component.dart';
import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/utils/get_size_without_context.dart';

class Kazoku extends FlameGame with TapCallbacks {
  /// Is longTap
  bool isLongTap = false;

  /// The player
  late CharacterComponent player;

  @override
  Future<void> onLoad() async {
    print("Kazoku -- onLoad");
    // "assets/images/sprites/character/Body_brown.png"
    CharacterData data = CharacterData(
      id: "sadad",
      name: "Jordan",
      gender: Gender.male,
      age: 22,
      bodyTexture: "sprites/character/Body_Brown.png",
      eyeTexture: "assets/images/sprites/character/Body_brown.png",
      hairstyleTexture: "assets/images/sprites/character/Body_brown.png",
      outfitTexture: "assets/images/sprites/character/Body_brown.png",
    );
    player = CharacterComponent(data: data);
    add(player);

    Vector2 size = getScreenSizeWithoutContext();

    player.position = Vector2(size.x / 2, size.y / 2);
  }

  @override
  void onTapDown(TapDownEvent event) {
    isLongTap = false;
    player.moveTo(event.localPosition);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    isLongTap = false;
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    isLongTap = true;
    player.moveTo(event.localPosition, shouldRun: true);
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Reset movement to not run
    // player.moveTo(event.localPosition);
    isLongTap = false;
  }
}
