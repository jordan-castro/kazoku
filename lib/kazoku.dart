import 'dart:async';
import 'dart:convert';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:kazoku/components/character/component.dart';
import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/components/kazu_floor/component.dart';
import 'package:kazoku/database/database.dart';
import 'package:kazoku/model/character_generator.dart';
import 'package:kazoku/overlays/room_editor.dart';
import 'package:kazoku/utils/get_size_without_context.dart';

class Kazoku extends FlameGame with TapCallbacks {
  /// The player
  late CharacterComponent player;
  late KazuFloorComponent currentFloor;

  @override
  Future<void> onLoad() async {
    await initializeDB();
    currentFloor = await loadFloor(1);
    add(currentFloor);

    player = (await loadPlayer())!;
    add(player);

    Vector2 size = getScreenSizeWithoutContext();

    player.position = Vector2(size.x / 2, size.y / 2);

    overlays.add(RoomEditorOverlay.overlay);
  }

  /// Load the player character.
  Future<CharacterComponent?> loadPlayer() async {
    // String playerId = await StorageManager.readData("playerId");
    // JSON? characterJson = await DbHelper.instance.queryCharacter("1");

    return CharacterComponent(
      data: (await CharacterData.loadCharacterFromId(1))!,
    );
  }

  Future<KazuFloorComponent> loadFloor(int floorId) async {
    // data
    final floorRow = await DbHelper.instance.queryFloor(floorId);
    print(floorRow);
    return KazuFloorComponent(
      map: jsonDecode(floorRow![DbHelper.kfm_Map]),
      floorNumber: floorRow[DbHelper.kfm_FloorNumber],
      id: floorRow[DbHelper.kfm_IdCol],
      name: floorRow[DbHelper.kfm_Name],
    );
  }

  /// Initialize the DB.
  Future<void> initializeDB() async {
    await DbHelper.instance.initializeDatabase();
  }
}
