import 'dart:async';

import 'package:flame/components.dart';
import 'package:kazoku/components/character/component.dart';

/// The base class for all addons on Character.
class AddonComponent extends SpriteAnimationComponent {
  /// Path to the texture
  final String texturePath;

  AddonComponent({required this.texturePath});

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
    throw Exception("Load animations is not implemented.");
  }

  @override
  FutureOr<void> onLoad() async {
    await loadAnimations();
  }
}
