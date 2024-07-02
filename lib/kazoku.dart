import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:kazoku/gui/character_builder.dart';
import 'package:kazoku/player/base.dart';
import 'package:kazoku/utils/storage_manager.dart';

class Kazoku extends FlameGame with TapCallbacks {
  late Player player;

  /// Is longTap
  bool isLongTap = false;

  @override
  Future<void> onLoad() async {
    print("Kazoku -- onLoad");
    player = Player();
    // Check if we need to go from the begining.
    final isFirstTimePlaying =
        await StorageManager.readData("isFirstTimePlaying") ?? true;

    // If first time playing:
    // 1. character generator
    overlays.add(CharacterBuilder.name);
  }

  @override
  void onTapDown(TapDownEvent event) {
    isLongTap = false;
    // player.moveTo(event.localPosition);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    isLongTap = false;
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    isLongTap = true;
    // player.moveTo(event.localPosition, shouldRun: true);
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Reset movement to not run
    // player.moveTo(event.localPosition);
    isLongTap = false;
  }
}
