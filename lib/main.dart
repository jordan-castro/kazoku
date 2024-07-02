import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:kazoku/gui/character_builder.dart';
import 'package:kazoku/kazoku.dart';

void main() {
  print("Kazoku Start");
  runApp(
    GameWidget(
      game: Kazoku(),
      loadingBuilder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
        // return const SplashScreen();
      },
      overlayBuilderMap: {
        CharacterBuilder.name: (context, game) => CharacterBuilder(
              game: game as Kazoku,
            ),
      },
    ),
  );
}

// class KazokuApp extends StatelessWidget {
//   const KazokuApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       routes: {
//         SplashScreen.routeName: (context) => const SplashScreen(),
//         GameScreen.routeName: (context) => const GameScreen(),
//       },
//       initialRoute: SplashScreen.routeName,
//     );
//   }
// }
