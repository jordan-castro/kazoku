import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:kazoku/components/character/addon.dart';
import 'package:kazoku/components/character/component.dart';

class OutfitComponent extends AddonComponent {
  OutfitComponent({required super.texturePath});
  
  @override
  Future<void> loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await Flame.images.load(texturePath),
      srcSize: Vector2(32, 46),
    );

    // Idle animations
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
}