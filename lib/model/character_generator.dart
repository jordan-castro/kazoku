import 'package:kazoku/components/character/addon.dart';
import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/utils/database.dart';
import 'dart:math' as math;

import 'package:sqflite/sqflite.dart';

class CharacterGenerator {
  Addon? body;
  Addon? eyes;
  Addon? hairstyle;
  Addon? outfit;

  /// Generate a character Data. (using a custom written model)
  ///
  /// **Return**
  Future<CharacterData> generateCharacter() async {
    // First is determinig the body.
    // Get all id/attributes of bodies in the databse.
    final database = await DbHelper.instance.database;
    final rng = math.Random();

    await _generateBody(database, rng);
    await _generateEyes(database, rng);

    // Choose a hairstyle which should match the eye color
    if (rng.nextDouble() > 0.2) {
      // Is not bald
    }

    // Choose a random outfit
    await _generateOutfit(database, rng);

    // The characters gender
    final gender = rng.nextBool() ? Gender.male : Gender.female;

    final characterData = CharacterData(
      id: (await _getLastId(database)) + 1,
      name: await _randomName(database, gender, rng),
      gender: gender,
      age: rng.nextInt(51) + 2,
      bodyTexture: body,
      eyeTexture: eyes,
      hairstyleTexture: hairstyle,
      outfitTexture: outfit,
    );

    // save character to database.
    // await CharacterGenerator.saveCharacter(characterData);
    return characterData;
  }

  /// CHOOSE a random name from our list of names.
  Future<String> _randomName(
    Database db,
    Gender gender,
    math.Random rng,
  ) async {
    final rows = await db.query(
      DbHelper.nameOptionsTable,
      where:
          "${DbHelper.no_genderCol} = ${gender.asInt} OR ${DbHelper.no_genderCol} = 2",
    );
    final row = rows[rng.nextInt(rows.length)];

    return row[DbHelper.no_nameCol] as String;
  }

  /// Get the most recent id of the characters table.
  Future<int> _getLastId(Database db) async {
    // Get last character
    final rows = await db.rawQuery(
      "SELECT id FROM ${DbHelper.charactersTable} ORDER BY DESC LIMIT 1",
    );
    final row = rows[0];
    return int.parse(row[DbHelper.characterIdCol] as String);
  }

  /// generaetg the body
  Future<void> _generateBody(Database db, math.Random rng) async {
    final allBodies = await db.query(
      DbHelper.characterTexturesTable,
      where: "${DbHelper.ct_TypeCol} = 'body'",
    );

    // choose a random option
    final bodyRow = allBodies[rng.nextInt(allBodies.length)];
    body = Addon.fromJson(bodyRow);
  }

  /// Generate the eyes
  Future<void> _generateEyes(Database database, math.Random rng) async {
    // Choose a random eyes
    final allEyes = await database.query(
      DbHelper.characterTexturesTable,
      where: "${DbHelper.ct_TypeCol} = 'eyes'",
    );

    final eyesRow = allEyes[rng.nextInt(allEyes.length)];
    eyes = Addon.fromJson(eyesRow);
  }

  /// Generate the outfit
  Future<void> _generateOutfit(Database database, math.Random rng) async {
    final outfitsAmount = await database.query(
      DbHelper.characterTexturesTable,
      columns: [DbHelper.ct_IdCol],
      where: "${DbHelper.ct_TypeCol} = 'outfit'",
    );
    final outfitNumber = rng.nextInt(outfitsAmount.length);

    // Choose random outfit color
    final outfitsOfNumber = await database.query(
      DbHelper.characterTexturesTable,
      where: "${DbHelper.ct_NameCol} LIKE '%$outfitNumber%'",
    );

    final outfitRow = outfitsOfNumber[rng.nextInt(outfitsOfNumber.length)];
    outfit = Addon.fromJson(outfitRow);
  }
}
