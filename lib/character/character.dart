import 'package:kazoku/character/paint/body.dart';
import 'package:kazoku/character/paint/eyes.dart';
import 'package:kazoku/character/paint/hairstyles.dart';
import 'package:kazoku/character/paint/outfit.dart';
import 'package:kazoku/character/paint/paint.dart';
import 'package:kazoku/utils/json.dart';

/// All characters (Npc, Player, Pet, etc) extend this class
class Character {
  /// Character ID
  final int id;

  /// The father of this character.
  final Character father;

  /// The mother of this character.
  final Character mother;

  /// The age of the character.
  final int age;

  /// The body texture for this character.
  final Body body;

  /// The eye texture for this character.
  final Eyes eyes;

  /// The hairstyle texture
  final Hairstyle hairstyle;

  /// The outfit texture
  final Outfit outfit;

  /// Has a smartphone?
  final bool hasSmartphone;

  /// If hasSmartphone is true, the texture
  Paint? smartphone;

  Character({
    required this.id,
    required this.father,
    required this.mother,
    required this.age,
    required this.body,
    required this.eyes,
    required this.hairstyle,
    required this.outfit,
    required this.hasSmartphone,
  });

  static Character fromJson(JSON characterJson) {
    return Character(
      id: characterJson['id'],
      father: characterJson['father'],
      mother: characterJson['mother'],
      age: characterJson['age'],
      body: characterJson['bodyTexture'],
      eyes: characterJson['eyeTexture'],
      hairstyle: characterJson['hairstyleTexture'],
      outfit: characterJson['outfitTexture'],
      hasSmartphone: characterJson['hasSmartphone'],
    );
  }

  /// Method to retrieve children of CHARACTER
  List<Character>? getChildren() {
    return null;
  }

  /// Is this character a kid?
  bool isAKid() {
    return age < 18;
  }
}
