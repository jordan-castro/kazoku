import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:kazoku/components/character/body.dart';
import 'package:kazoku/components/character/data.dart';
import 'package:kazoku/components/character/eyes.dart';
import 'package:kazoku/components/character/hairstyle.dart';
import 'package:kazoku/components/character/outfit.dart';
import 'package:kazoku/utils/character_animations.dart';

/// Directions a character component can face.
enum CharacterDirection { left, right, awayFromCamera, towardsCamera }

/// Character states. (is used for the animation)
enum CharacterState { idle, walk, run }

// Step time for idle animations
const idleStepTime = 0.25;
// Step for walk animations
const walkStepTime = 0.20;
// Step for run
const runStepTime = 0.15;

/// The character component, All NPCs, Players, Pets, ETC. come from this
/// component. (Player and NPC are the same only that player has more choices.)
class CharacterComponent extends PositionComponent {
  final CharacterData data;
  CharacterDirection direction = CharacterDirection.towardsCamera;
  CharacterState state = CharacterState.idle;

  /// Animations for a character.
  CharacterAnimations animations = {};

  CharacterComponent({required this.data});

  /// The body component
  late BodyComponent bodyComponent;

  /// The eyes component
  late EyesComponent eyesComponent;

  /// The outfit component
  late OutfitComponent outfitComponent;

  /// The hairstyle component
  late HairstyleComponent hairstyleComponent;

  /// Current effect.
  Effect? currentEffect;

  /// Walking speed
  final double walkSpeed = 200;

  /// Running speed
  final double runSpeed = 400;

  /// Convert direction and character state into a string.
  static String determineAnimation(
      CharacterState state, CharacterDirection direction) {
    return state.toString().split(".").last +
        direction.toString().split(".").last;
  }

  @override
  FutureOr<void> onLoad() async {
    // Load components
    bodyComponent = BodyComponent(addon: data.bodyTexture!);
    await bodyComponent.addToParent(this);
    eyesComponent = EyesComponent(addon: data.eyeTexture!);
    await eyesComponent.addToParent(this);
    outfitComponent = OutfitComponent(addon: data.outfitTexture!);
    await outfitComponent.addToParent(this);
    hairstyleComponent = HairstyleComponent(addon: data.hairstyleTexture!);
    await hairstyleComponent.addToParent(this);

    // Animation
    _updateAnimation();
  }

  /// Move the character to a new position.
  /// The [position] parameter represents the target position.
  /// The [shouldRun] parameter is optional and indicates whether the movement
  /// should be in a running state.
  void moveTo(Vector2 position, {bool shouldRun = false}) {
    if (currentEffect != null) {
      // Remove previous effect
      remove(currentEffect!);
    }

    // Determine speed needed based on shouldRun
    double speed = shouldRun ? runSpeed : walkSpeed;
    // Update state
    CharacterState stateToUpdateTo =
        shouldRun ? CharacterState.run : CharacterState.walk;

    // Get difference to position from current
    Vector2 difference = Vector2(
      this.position.x - position.x,
      this.position.y - position.y,
    );

    // Which direction is the player facing?
    if (difference.x.abs() > difference.y.abs()) {
      // Left or right
      if (difference.x > 0) {
        updateDirection(CharacterDirection.left);
      } else if (difference.x < 0) {
        updateDirection(CharacterDirection.right);
      }
    } else {
      // Y axis
      if (difference.y > 0) {
        updateDirection(CharacterDirection.awayFromCamera);
      } else if (difference.y < 0) {
        updateDirection(CharacterDirection.towardsCamera);
      }
    }

    // Create the effect
    currentEffect = MoveEffect.to(
      position,
      EffectController(
        speed: speed,
      ),
      onComplete: () {
        // Update position when finished.
        this.position = position;
        updateState(CharacterState.idle);
        _updateAnimation();
        // Set currentEffect
        currentEffect = null;
      },
    );

    updateState(stateToUpdateTo);
    // Add effect to start
    add(currentEffect!);

    // Update animation
    _updateAnimation();
  }

  /// Update the satte of the character
  void updateState(CharacterState newState) {
    if (state != newState) {
      state = newState;
    }
  }

  /// Update the direction the character is facing
  void updateDirection(CharacterDirection direction) {
    if (this.direction != direction) {
      this.direction = direction;
    }
  }

  /// Update the current animation state
  void _updateAnimation() {
    bodyComponent.updateAnimation(state, direction);
    eyesComponent.updateAnimation(state, direction);
    outfitComponent.updateAnimation(state, direction);
    hairstyleComponent.updateAnimation(state, direction);
  }
}
