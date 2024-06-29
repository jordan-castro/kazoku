import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:kazoku/player/base.dart';

class Kazoku extends FlameGame with TapCallbacks {
  Kazoku();
  late Player player;

  @override
  FutureOr<void> onLoad() async {
    player = Player();
    add(player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.moveTo(event.localPosition);
  }

  @override
  void onTapCancel(TapCancelEvent event) {}

  @override
  void onLongTapDown(TapDownEvent event) {
    player.moveTo(event.localPosition, shouldRun: true);
  }

  @override
  void onTapUp(TapUpEvent event) {}
}
