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

/// CharacterData, this class holds all the data for a CharacterComponent.
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
    this.bodyTexture,
    this.eyeTexture,
    this.hairstyleTexture,
    this.outfitTexture,
    this.accessories,
  });

  /// Basic constructor
  factory CharacterData.fromJson(JSON json) {
    return CharacterData(
      id: json['id'],
      name: json['name'],
      gender: json['gender'] == 0 ? Gender.female : Gender.male,
      age: toIntOrNull(json['age'])!,
    );
  }

  /// Is this character a kid? (think toddler)
  bool isKid() {
    return age <= 4;
  }

  Future<void> loadBodyFromId(int textureId) async {
    bodyTexture = await _loadTextureFromId(textureId);
  }

  Future<void> loadHairstyleFromId(int textureId) async {
    hairstyleTexture = await _loadTextureFromId(textureId);
  }

  Future<void> loadEyesFromId(int textureId) async {
    eyeTexture = await _loadTextureFromId(textureId);
  }

  Future<void> loadOutfitFromId(int textureId) async {
    outfitTexture = await _loadTextureFromId(textureId);
  }

  Future<Addon?> _loadTextureFromId(int textureId) async {
    final db = DbHelper.instance;
    final result = await db.queryTexture(textureId);
    if (result == null) {
      return null;
    }
    return Addon.fromJson(result);
  }

  /// When we have a JSON that contains the id of textures this should be called.
  /// This is usuallly the case when a NPC who is not saved to the DB is generated.
  static Future<CharacterData> loadWithTextureIDJson(JSON json) async {
    final data = CharacterData.fromJson(json);
    await data._loadTexturesFromJSON(json);
    return data;
  }


  Future<void> _loadTexturesFromJSON(JSON json) async {
    if (json.containsKey(DbHelper.characterBodyTextureCol)) {
      await loadBodyFromId(json[DbHelper.characterBodyTextureCol]);
    }
    if (json.containsKey(DbHelper.characterEyesTextureCol)) {
      await loadEyesFromId(json[DbHelper.characterEyesTextureCol]);
    }
    if (json.containsKey(DbHelper.characterHairstyleTextureCol)) {
      await loadHairstyleFromId(json[DbHelper.characterHairstyleTextureCol]);
    }
    if (json.containsKey(DbHelper.characterOutfitTextureCol)) {
      await loadOutfitFromId(json[DbHelper.characterOutfitTextureCol]);
    }
  }

  static Future<CharacterData?> loadCharacterFromId(int id) async {
    final db = DbHelper.instance;
    final characterJson = await db.queryCharacter(id);
    print(characterJson);
    if (characterJson == null) {
      return null;
    }

    final characterData = CharacterData.fromJson(characterJson);
    await characterData._loadTexturesFromJSON(characterJson);
    return characterData;
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
