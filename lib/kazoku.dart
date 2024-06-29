import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:kazoku/player/base.dart';

class Kazoku extends FlameGame with TapCallbacks {
  Kazoku();
  late Player player;

  /// Is longTap
  bool isLongTap = false;

  @override
  FutureOr<void> onLoad() async {
    player = Player();
    add(player);
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
    player.moveTo(event.localPosition);
    isLongTap = false;
  }
}
