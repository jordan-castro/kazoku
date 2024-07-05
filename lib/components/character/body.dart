import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:kazoku/components/character/addon.dart';
import 'package:kazoku/components/character/component.dart';

/// The body componetn
class BodyComponent extends AddonComponent {
  BodyComponent({required super.texturePath});

  @override
  FutureOr<void> onLoad() async {
    print("BodyComponent onLoad ---");
    final spriteSheet = SpriteSheet(
      image: await Flame.images.load(
        texturePath,
      ),
      srcSize: Vector2(30, 64),
    );

    // Step time for idle animations
    const idleStepTime = 0.5;

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
  }
}
