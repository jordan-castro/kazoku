import 'dart:convert';

import 'package:kazoku/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> insertFloors(Database db) async {
  print("Inserting floors");
  await db.insert(DbHelper.kazuFloorsMapTable, {
    DbHelper.kfm_IdCol: 1,
    DbHelper.kfm_Name: "First",
    DbHelper.kfm_FloorNumber: "L",
    DbHelper.kfm_Map: jsonEncode({
      "layers": {
        "0": [
          [1, 1, 1, 1, 1, 1, 1],
          [1, 1, 1, 1, 1, 1, 1]
        ],
      }
    }),
  });
}
