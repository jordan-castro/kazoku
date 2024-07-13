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
    player = (await loadPlayer())!;
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
    player.moveTo(event.localPosition);
    isLongTap = false;
  }

  /// Load the player character.
  Future<CharacterComponent?> loadPlayer() async {
    // String playerId = await StorageManager.readData("playerId");
    // JSON? characterJson = await DbHelper.instance.queryCharacter("1");

    // The player does not exist, should create one for first time.
    // if (characterJson == null) {
    //   return null;
    // }

    // TODO: Load any accessories

    return CharacterComponent(
        data: (await CharacterData.loadCharacterFromId(1))!);
  }
}
