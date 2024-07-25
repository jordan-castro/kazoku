import 'package:kazoku/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> insertObjectHeaders(Database db) async {
  await db.insert(DbHelper.objectHeadersTable, {
    DbHelper.oh_IdCol: 1,
    DbHelper.oh_title: "Floors"
  });
  //   await db.insert(DbHelper.objectHeadersTable, {
  //   DbHelper.oh_IdCol: 1,
  //   DbHelper.oh_title: "Floors"
  // });
}


 