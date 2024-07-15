import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/utils/database.dart';
import 'package:sqflite/sqflite.dart';

/// Save a character to the Kazoku.db
Future<void> saveCharacter(CharacterData data) async {
  await DbHelper.instance.insertIntoTable(
    DbHelper.charactersTable,
    data.toJson(),
  );
}
