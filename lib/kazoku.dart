import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:kazoku/components/character/component.dart';
import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/model/character_generator.dart';
import 'package:kazoku/utils/get_size_without_context.dart';

class Kazoku extends FlameGame with TapCallbacks {
  /// The player
  late CharacterComponent player;

  @override
  Future<void> onLoad() async {
    player = (await loadPlayer())!;
    add(player);

    Vector2 size = getScreenSizeWithoutContext();

    player.position = Vector2(size.x / 2, size.y / 2);
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
    final characterGenerator = CharacterGenerator();
    return CharacterComponent(
      data: await characterGenerator.generateGeminiCharacter(),
    );
    // return CharacterComponent(
    //   data: (await CharacterData.loadCharacterFromId(1))!,
    // );
  }
}
