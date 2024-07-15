import 'package:kazoku/components/character/addon.dart';
import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/utils/database.dart';
import 'dart:math' as math;

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
    final allBodies = await database.query(
      DbHelper.characterTexturesTable,
      where: "${DbHelper.ct_TypeCol} = body",
    );

    final rng = math.Random();

    // choose a random option
    final bodyRow = allBodies[rng.nextInt(allBodies.length)];
    body = Addon.fromJson(bodyRow);

    // Choose a random eye and hairstyle
    // final allEyes = await database.query(DbHelper.characterTexturesTable)
  }
}
