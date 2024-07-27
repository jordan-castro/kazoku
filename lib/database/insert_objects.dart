import 'package:kazoku/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqflite.dart';

Future<void> insertObjects(Database db) async {
  final batch = db.batch();

  batch.insert(
    DbHelper.staticObjectsTable,
    {
      DbHelper.so_IdCol: 1,
      DbHelper.so_HeaderId: 2,
      DbHelper.so_Name: "Bed 1",
      DbHelper.so_Source:
          "kazu_floor_assets/bedroom/Bedroom_Singles_Shadowless_32x32_1.png",
    },
  );

  await batch.commit();
}
