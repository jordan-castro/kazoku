import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/database/database.dart';

/// Save a character to the Kazoku.db
Future<void> saveCharacter(CharacterData data) async {
  await DbHelper.instance.insertIntoTable(
    DbHelper.charactersTable,
    data.toJson(),
  );
}
