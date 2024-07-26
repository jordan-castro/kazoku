import 'package:kazoku/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> insertObjectHeaders(Database db) async {
  await db.insert(DbHelper.objectHeadersTable, {
    DbHelper.oh_IdCol: 1,
    DbHelper.oh_title: "Floors"
  });
  await db.insert(DbHelper.objectHeadersTable, {
    DbHelper.oh_IdCol: 2,
    DbHelper.oh_title: "Bedroom"
  });
  await db.insert(DbHelper.objectHeadersTable, {
    DbHelper.oh_IdCol: 3,
    DbHelper.oh_title: "Bathroom"
  });
  await db.insert(DbHelper.objectHeadersTable, {
    DbHelper.oh_IdCol: 4,
    DbHelper.oh_title: "Living room"
  });
}


 