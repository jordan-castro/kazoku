import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku/gui/character_builder.dart';
import 'package:kazoku/kazoku.dart';

class GameScreen extends StatelessWidget {
  static const routeName = "/game";

  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: Kazoku(),
      overlayBuilderMap: {
        'PauseMenu': (context, game) {
          return Container();
        },
        'CharacterBuilder': (context, game) {
          return CharacterBuilder(game: game as Kazoku);
        }
      },
    );
  }
}
