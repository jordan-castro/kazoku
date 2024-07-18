import 'dart:convert';

import 'package:kazoku/components/character/addon.dart';
import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/gemini/prompt.dart';
import 'package:kazoku/utils/database.dart';
import 'dart:math' as math;

import 'package:sqflite/sqflite.dart';

class CharacterGenerator {
  Addon? _body;
  Addon? _eyes;
  Addon? _hairstyle;
  Addon? _outfit;

  /// Generate a Character Data from GEMINI api.
  Future<CharacterData> generateGeminiCharacter() async {
    // get access to the database
    final db = await DbHelper.instance.database;
    // Get all textures
    final textures = await db.query(DbHelper.characterTexturesTable);
    final gptResponse = await promptCharacterGenerator(textures);
    print(gptResponse);
    if (gptResponse != null) {
      print("GPT character");
      // Parse it
      final characterGpt = jsonDecode(gptResponse);
      return CharacterData.fromJson(characterGpt);
    }
    print("Non GPT character");

    return generateCharacter();
  }

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
      await _generateHairstyle(database, rng);
    }

    // Choose a random outfit
    await _generateOutfit(database, rng);

    // The characters gender
    final gender = rng.nextBool() ? Gender.male : Gender.female;

    final characterData = CharacterData(
      id: (await _getLastId(database)) + 1,
      // name: await _randomName(database, gender, rng),
      name: "random",
      gender: gender,
      age: rng.nextInt(51) + 2,
      bodyTexture: _body,
      eyeTexture: _eyes,
      hairstyleTexture: _hairstyle,
      outfitTexture: _outfit,
    );

    // save character to database.
    // await CharacterGenerator.saveCharacter(characterData);
    return characterData;
  }

  /// Generate a hairstyle.
  Future<void> _generateHairstyle(Database db, math.Random rng) async {
    final rows = await db.query(
      DbHelper.characterTexturesTable,
      where: "${DbHelper.ct_TypeCol} = 'hairstyle'",
    );
    _hairstyle = Addon.fromJson(
      rows[rng.nextInt(rows.length)],
    );
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
      "SELECT id FROM ${DbHelper.charactersTable} ORDER BY id DESC LIMIT 1",
    );
    final row = rows[0];
    return row[DbHelper.characterIdCol] as int;
  }

  /// generaetg the body
  Future<void> _generateBody(Database db, math.Random rng) async {
    final allBodies = await db.query(
      DbHelper.characterTexturesTable,
      where: "${DbHelper.ct_TypeCol} = 'body'",
    );
    // choose a random option
    final bodyRow = allBodies[rng.nextInt(allBodies.length)];
    _body = Addon.fromJson(bodyRow);
  }

  /// Generate the eyes
  Future<void> _generateEyes(Database database, math.Random rng) async {
    // Choose a random eyes
    final allEyes = await database.query(
      DbHelper.characterTexturesTable,
      where: "${DbHelper.ct_TypeCol} = 'eyes'",
    );

    final eyesRow = allEyes[rng.nextInt(allEyes.length)];
    _eyes = Addon.fromJson(eyesRow);
  }

  /// Generate the outfit
  Future<void> _generateOutfit(Database database, math.Random rng) async {
    final outfitsAmount = await database.query(
      DbHelper.characterTexturesTable,
      columns: [DbHelper.ct_NameCol],
      where: "${DbHelper.ct_TypeCol} = 'outfit'",
    );
    final outfitNumber = outfitsAmount[rng.nextInt(outfitsAmount.length)]
            [DbHelper.ct_NameCol]
        .toString()
        .split(" ")
        .last;

    print(outfitNumber);

    // Choose random outfit color
    final outfitsOfNumber = await database.query(
      DbHelper.characterTexturesTable,
      where:
          "${DbHelper.ct_NameCol} LIKE '%$outfitNumber%' AND ${DbHelper.ct_TypeCol} = 'outfit'",
    );

    final outfitRow = outfitsOfNumber[rng.nextInt(outfitsOfNumber.length)];
    _outfit = Addon.fromJson(outfitRow);
  }
}
