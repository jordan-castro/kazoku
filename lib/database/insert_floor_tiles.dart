import 'package:kazoku/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// This is for testing purposes only!
///
/// In production the builder should be used ALWAYS!
Future<void> insertFloorTiles(Database db) async {
  var batch = db.batch();

  batch.insert(
    DbHelper.floorTilesTable,
    {
      DbHelper.ft_IdCol: 1,
      DbHelper.ft_Source:
          "kazu_floor_assets/tiles/Room_Builder_Floors_32x32.png",
      DbHelper.ft_Coords: "30,94;34,34",
      DbHelper.ft_HeaderId: 1,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  batch.insert(
    DbHelper.floorTilesTable,
    {
      DbHelper.ft_IdCol: 2,
      DbHelper.ft_Source:
          "kazu_floor_assets/tiles/Room_Builder_Floors_32x32.png",
      DbHelper.ft_Coords: "62,94;34,34",
      DbHelper.ft_HeaderId: 1,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  await batch.commit();
}
