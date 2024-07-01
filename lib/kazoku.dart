import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:kazoku/player/base.dart';
import 'package:kazoku/utils/storage_manager.dart';

class Kazoku extends FlameGame with TapCallbacks {
  Kazoku();
  late Player player;

  /// Is longTap
  bool isLongTap = false;

  /// Is this the first time playing?
  bool isFirstTimePlaying = true;

  @override
  FutureOr<void> onLoad() async {
    // Check if we need to go from the begining.
    isFirstTimePlaying =
        await StorageManager.readData("isFirstTimePlaying") ?? true;
    // player = Player();
    // add(player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    isLongTap = false;
    // if ()
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
    player.moveTo(event.localPosition);
    isLongTap = false;
  }
}
