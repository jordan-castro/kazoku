import 'dart:async';

import 'package:flame/components.dart';
import 'package:kazoku/components/kazu_floor/object.dart';
import 'package:kazoku/components/kazu_floor/objects/tile.dart';
import 'package:kazoku/database/database.dart';

class Floor extends MultiObjectComponent {
  final List tiles;

  Floor({required this.tiles});

  @override
  FutureOr<void> onLoad() async {
    // For each tile load a texture from it's id
    for (int i = 0; i < tiles.length; i++) {
      print(i);
      final row = tiles[i];
      assert(row is List, "The row must be a list: $row");
      for (int j = 0; j < row.length; j++) {
        final tile = row[j];
        assert(tile is int, "The tile must be an int: $tile");

        final tileQuery = await DbHelper.instance.queryFloorTile(tile);
        if (tileQuery == null) {
          continue;
        }
        final tComp = TileComponent(
          coords: tileQuery[DbHelper.ft_Coords],
          source: tileQuery[DbHelper.ft_Source],
        );

        add(tComp);
        tComp.position = Vector2(
          j * 32.0,
          i * 32.0,
        );
      }
    }
  }
}
