import 'dart:async';

import 'package:flame/components.dart';
import 'package:kazoku/components/character/body.dart';
import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/utils/character_animations.dart';

/// Directions a character component can face.
enum CharacterDirection { left, right, awayFromCamera, towardsCamera }

/// Character states. (is used for the animation)
enum CharacterState { idle, walk }

/// The character component, All NPCs, Players, Pets, ETC. come from this
/// component. (Player and NPC are the same only that player has more choices.)
class CharacterComponent extends PositionComponent {
  final CharacterData data;
  CharacterDirection direction = CharacterDirection.towardsCamera;
  CharacterState state = CharacterState.idle;

  /// Animations for a character.
  CharacterAnimations animations = {};

  /// The speed of this character (No Velocity)
  double speed = 200;

  CharacterComponent({required this.data});

  /// The body component
  late BodyComponent bodyComponent;

  /// Convert direction and character state into a string.
  static String determineAnimation(
      CharacterState state, CharacterDirection direction) {
    return state.toString().split(".").last +
        direction.toString().split(".").last;
  }

  @override
  FutureOr<void> onLoad() async {
    // Load components
    bodyComponent = BodyComponent(texturePath: data.bodyTexture);
    await bodyComponent.addToParent(this);
    bodyComponent.updateAnimation(state, CharacterDirection.right);
  }
}
