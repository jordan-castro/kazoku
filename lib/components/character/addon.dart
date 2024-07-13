import 'dart:async';
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:kazoku/components/character/component.dart';
import 'package:kazoku/utils/database.dart';
import 'package:kazoku/utils/json.dart';

enum AddonType { body, eyes, hairstyle, outfit, other }

/// Addon data class
class Addon {
  final int id;
  final String name;
  final AddonType addonType;
  final String path;
  final Map<String, dynamic> attributes;

  Addon({
    required this.id,
    required this.name,
    required this.addonType,
    required this.path,
    required this.attributes,
  });

  factory Addon.fromJson(JSON json) {
    String attributes = json[DbHelper.ct_attributes] as String;
    if (attributes.isEmpty) {
      attributes = "{}";
    }

    return Addon(
      id: toIntOrNull(json[DbHelper.ct_IdCol])!,
      name: json[DbHelper.ct_NameCol],
      addonType: addonTypeFromString(json[DbHelper.ct_TypeCol]),
      path: json[DbHelper.ct_TexturePath],
      attributes: jsonDecode(attributes.replaceAll("'", '"')),
    );
  }

  static AddonType addonTypeFromString(String string) {
    switch (string.toLowerCase()) {
      case "body":
        {
          return AddonType.body;
        }
      case "eyes":
        {
          return AddonType.eyes;
        }
      case "hairstyle":
        {
          return AddonType.hairstyle;
        }
      case "outfit":
        {
          return AddonType.outfit;
        }
      case "other":
        {
          return AddonType.other;
        }
      case _:
        {
          return AddonType.other;
        }
    }
  }
}

/// The base class for all addons on Character.
class AddonComponent extends SpriteAnimationComponent {
  final Addon addon;

  AddonComponent({required this.addon});

  /// The animations in a form of a `Map<String, SpriteAnimation>`
  Map<String, SpriteAnimation> animations = {};

  /// Update the animation for the addon.
  void updateAnimation(CharacterState state, CharacterDirection direction) {
    // Check if animaiton exists
    final key = CharacterComponent.determineAnimation(state, direction);
    if (animations.containsKey(key)) {
      animation = animations[key];
    }
  }

  /// Load the animations
  Future<void> loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await Flame.images.load(
        addon.path,
      ),
      srcSize: Vector2(32, 64),
    );

    // Add to animations
    animations[CharacterComponent.determineAnimation(
      CharacterState.idle,
      CharacterDirection.right,
    )] = spriteSheet.createAnimation(
      row: 1,
      stepTime: idleStepTime,
      from: 0,
      to: 5,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.idle,
      CharacterDirection.awayFromCamera,
    )] = spriteSheet.createAnimation(
      row: 1,
      stepTime: idleStepTime,
      from: 6,
      to: 11,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.idle,
      CharacterDirection.left,
    )] = spriteSheet.createAnimation(
      row: 1,
      stepTime: idleStepTime,
      from: 12,
      to: 17,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.idle,
      CharacterDirection.towardsCamera,
    )] = spriteSheet.createAnimation(
      row: 1,
      stepTime: idleStepTime,
      from: 18,
      to: 23,
    );

    // walk animation
    animations[CharacterComponent.determineAnimation(
      CharacterState.walk,
      CharacterDirection.right,
    )] = spriteSheet.createAnimation(
      row: 2,
      stepTime: walkStepTime,
      from: 0,
      to: 5,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.walk,
      CharacterDirection.awayFromCamera,
    )] = spriteSheet.createAnimation(
      row: 2,
      stepTime: walkStepTime,
      from: 6,
      to: 11,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.walk,
      CharacterDirection.left,
    )] = spriteSheet.createAnimation(
      row: 2,
      stepTime: walkStepTime,
      from: 12,
      to: 17,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.walk,
      CharacterDirection.towardsCamera,
    )] = spriteSheet.createAnimation(
      row: 2,
      stepTime: walkStepTime,
      from: 18,
      to: 23,
    );

    // RUN animation
    animations[CharacterComponent.determineAnimation(
      CharacterState.run,
      CharacterDirection.right,
    )] = spriteSheet.createAnimation(
      row: 2,
      stepTime: runStepTime,
      from: 0,
      to: 5,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.run,
      CharacterDirection.awayFromCamera,
    )] = spriteSheet.createAnimation(
      row: 2,
      stepTime: runStepTime,
      from: 6,
      to: 11,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.run,
      CharacterDirection.left,
    )] = spriteSheet.createAnimation(
      row: 2,
      stepTime: runStepTime,
      from: 12,
      to: 17,
    );
    animations[CharacterComponent.determineAnimation(
      CharacterState.run,
      CharacterDirection.towardsCamera,
    )] = spriteSheet.createAnimation(
      row: 2,
      stepTime: runStepTime,
      from: 18,
      to: 23,
    );
  }

  @override
  FutureOr<void> onLoad() async {
    await loadAnimations();
  }
}
