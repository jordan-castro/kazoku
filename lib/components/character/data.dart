import 'package:kazoku/utils/json.dart';

/// Gender Enum
enum Gender { male, female }

class CharacterData {
  /// A unique string by which this character can be identified.
  final String id;

  /// The Name of this character
  final String name;

  /// The gender of this character.
  final Gender gender;

  /// The age of this character
  final int age;

  /// The body texture path.
  final String bodyTexture;

  /// The eye texture path.
  final String eyeTexture;

  /// The hairstyle texture path.
  final String hairstyleTexture;

  /// The outfit texture path.
  final String outfitTexture;

  /// A Map of accessories [name => path to texture] this character has on.
  final Map<String, String>? accessories;

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

  factory CharacterData.fromJson(JSON json) {
    return CharacterData(
      id: json['id'],
      name: json['name'],
      gender: json['gender'] == 0 ? Gender.female : Gender.male,
      age: toIntOrNull(json['age'])!,
      bodyTexture: json['bodyTexture'],
      eyeTexture: json['eyeTexture'],
      hairstyleTexture: json['hairstyleTexture'],
      outfitTexture: json['outfitTexture'],
    );
  }

  /// Is this character a kid? (think toddler)
  bool isKid() {
    return age <= 4;
  }
}
