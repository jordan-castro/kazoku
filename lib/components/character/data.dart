import 'package:kazoku/components/character/addon.dart';
import 'package:kazoku/utils/database.dart';
import 'package:kazoku/utils/json.dart';

/// Gender Enum
enum Gender { male, female }

extension GenderConversion on Gender {
  String get asString {
    switch (this) {
      case Gender.male:
        return "male";
      case Gender.female:
        return "female";
    }
  }

  int get asInt {
    switch (this) {
      case Gender.male:
        return 1;
      case Gender.female:
        return 0;
    }
  }
}

class CharacterData {
  /// A unique string by which this character can be identified.
  final int id;

  /// The Name of this character
  final String name;

  /// The gender of this character.
  final Gender gender;

  /// The age of this character
  final int age;

  /// The body texture path.
  Addon? bodyTexture;

  /// The eye texture path.
  Addon? eyeTexture;

  /// The hairstyle texture path.
  Addon? hairstyleTexture;

  /// The outfit texture path.
  Addon? outfitTexture;

  /// A Map of accessories [name => path to texture] this character has on.
  List<Addon>? accessories;

  CharacterData({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.bodyTexture,
    required this.eyeTexture,
    required this.hairstyleTexture,
    required this.outfitTexture,
    this.accessories,
  });

  factory CharacterData.fromJson(JSON json,
      {Addon? bodyTexture,
      Addon? eyeTexture,
      Addon? hairstyleTexture,
      Addon? outfitTexture}) {
    return CharacterData(
      id: json['id'],
      name: json['name'],
      gender: json['gender'] == 0 ? Gender.female : Gender.male,
      age: toIntOrNull(json['age'])!,
      bodyTexture: bodyTexture,
      eyeTexture: eyeTexture,
      hairstyleTexture: hairstyleTexture,
      outfitTexture: outfitTexture,
    );
  }

  /// Is this character a kid? (think toddler)
  bool isKid() {
    return age <= 4;
  }

  static Future<CharacterData?> loadCharacterFromId(int id) async {
    final db = DbHelper.instance;
    final characterJson = await db.queryCharacter(id);
    print(characterJson);
    if (characterJson == null) {
      return null;
    }

    print(await db.queryTexture(200));

    // We have the necessary data
    final bodyTextureJson = await db.queryTexture(
      characterJson[DbHelper.characterBodyTextureCol],
    );
    final eyesTextureJson = await db.queryTexture(
      characterJson[DbHelper.characterEyesTextureCol],
    );
    final hairstyleTextureJson = await db.queryTexture(
      characterJson[DbHelper.characterHairstyleTextureCol],
    );
    final outfitTextureJson = await db.queryTexture(
      characterJson[DbHelper.characterOutfitTextureCol],
    );

    return CharacterData.fromJson(
      characterJson,
      bodyTexture: Addon.fromJson(bodyTextureJson!),
      eyeTexture: Addon.fromJson(eyesTextureJson!),
      hairstyleTexture: Addon.fromJson(hairstyleTextureJson!),
      outfitTexture: Addon.fromJson(outfitTextureJson!),
    );
  }

  /// Convert this class into it's JSON equivalent.
  JSON toJson() {
    return {
      DbHelper.characterIdCol: id,
      DbHelper.characterNameCol: name,
      DbHelper.characterGenderCol: gender.asInt,
      DbHelper.characterAgeCol: age,
      DbHelper.characterBodyTextureCol: bodyTexture?.id,
      DbHelper.characterEyesTextureCol: eyeTexture?.id,
      DbHelper.characterHairstyleTextureCol: bodyTexture?.id,
      DbHelper.characterOutfitTextureCol: outfitTexture?.id,
    };
  }
}
