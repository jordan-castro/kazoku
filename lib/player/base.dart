import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:kazoku/kazoku.dart';
import 'package:kazoku/player/facing.dart';
import 'package:kazoku/player/state.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent with HasGameRef<Kazoku> {
  /// Current animation playing
  PlayerState state = PlayerState.idle;

  /// What directio is the player facing?
  PlayerFacing facing = PlayerFacing.front;

  /// Animations
  Map<String, SpriteAnimation> animations = {};

  /// Current aniomation string
  String animationString = "idle:front";

  /// Current effect.
  Effect? currentEffect;

  /// Base player speed
  static const double baseSpeed = 200;

  /// Run speed
  static const double runSpeed = 400;

  // /// Basic sprite sheet animaitons
  // late SpriteSheet basicSpriteSheet;

  // /// Complex sprite sheet animations
  // late SpriteSheet complexSpriteSheet;

  @override
  FutureOr<void> onLoad() async {
    // Load basic sprite sheet.
    final basicSpriteSheet = SpriteSheet(
      image: await Flame.images.load(
        "sprites/player/character.png",
      ),
      srcSize: Vector2(14, 16),
    );

    // -- Animations --
    // Idle
    animations[Player.stateFacing(PlayerState.idle, PlayerFacing.front)] =
        basicSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.5,
      from: 0,
      to: 2,
    );
    animations[Player.stateFacing(PlayerState.idle, PlayerFacing.back)] =
        basicSpriteSheet.createAnimation(
      row: 1,
      stepTime: 0.5,
      from: 0,
      to: 2,
    );
    animations[Player.stateFacing(PlayerState.idle, PlayerFacing.left)] =
        basicSpriteSheet.createAnimation(
      row: 2,
      stepTime: 0.5,
      from: 0,
      to: 2,
    );
    animations[Player.stateFacing(PlayerState.idle, PlayerFacing.right)] =
        basicSpriteSheet.createAnimation(
      row: 3,
      stepTime: 0.5,
      from: 0,
      to: 2,
    );
    // Walk
    animations[Player.stateFacing(PlayerState.walk, PlayerFacing.front)] =
        basicSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.25,
      from: 2,
      to: 4,
    );
    animations[Player.stateFacing(PlayerState.walk, PlayerFacing.back)] =
        basicSpriteSheet.createAnimation(
      row: 1,
      stepTime: 0.25,
      from: 2,
      to: 4,
    );
    animations[Player.stateFacing(PlayerState.walk, PlayerFacing.left)] =
        basicSpriteSheet.createAnimation(
      row: 2,
      stepTime: 0.25,
      from: 2,
      to: 4,
    );
    animations[Player.stateFacing(PlayerState.walk, PlayerFacing.right)] =
        basicSpriteSheet.createAnimation(
      row: 3,
      stepTime: 0.25,
      from: 2,
      to: 4,
    );

    size = NotifyingVector2(30, 30);

    // TODO: Advanced sheet
  }

  /// Update player state
  void updateState(PlayerState state) {
    // No need to change state if already current
    if (this.state == state) {
      return;
    }

    // Update state
    this.state = state;
  }

  /// Update player facing direction
  void updateFacing(PlayerFacing facing) {
    // No need to change facing if already current
    if (this.facing == facing) {
      return;
    }

    // Update value
    this.facing = facing;
  }

  /// Update animation
  void _updateAnimation() {
    String animationString = Player.stateFacing(state, facing);

    if (this.animationString == animationString) {
      // We are already being animated currectly.
      return;
    }

    // Update animation
    this.animationString = animationString;
    animation = animations[this.animationString];
  }

  /// Move to a specified position.
  ///
  /// The [position] parameter represents the target position.
  /// The [shouldRun] parameter is optional and indicates whether the movement
  /// should be in a running state.
  void moveTo(Vector2 position, {bool shouldRun = false}) {
    if (currentEffect != null) {
      // Remove previous effect
      remove(currentEffect!);
    }

    // Determine speed needed based on shouldRun
    double speed = shouldRun ? runSpeed : baseSpeed;

    // Get difference to position from current
    Vector2 difference = Vector2(
      this.position.x - position.x,
      this.position.y - position.y,
    );

    // Which direction is the player facing?
    if (difference.x.abs() > difference.y.abs()) {
      // Left or right
      if (difference.x > 0) {
        updateFacing(PlayerFacing.left);
      } else if (difference.x < 0) {
        updateFacing(PlayerFacing.right);
      }
    } else {
      // Y axis
      if (difference.y > 0) {
        updateFacing(PlayerFacing.back);
      } else if (difference.y < 0) {
        updateFacing(PlayerFacing.front);
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
        updateState(PlayerState.idle);
        _updateAnimation();
        // Set currentEffect
        currentEffect = null;
      },
    );

    // Update state
    updateState(PlayerState.walk);
    // Add effect to start
    add(currentEffect!);

    // Update animation
    _updateAnimation();
  }

  /// Create a state:facing string.
  static String stateFacing(PlayerState state, PlayerFacing facing) {
    String string = "";

    string += state.toString().split(".").last;
    string += ":";
    string += facing.toString().split(".").last;

    return string;
  }
}
