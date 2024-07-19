import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:kazoku/kazoku.dart';
import 'package:kazoku/overlays/room_editor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print("Kazoku Start");

  runApp(
    GameWidget(
      game: Kazoku(),
      loadingBuilder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      overlayBuilderMap: {
        RoomEditorOverlay.overlay: (context, game) => RoomEditorOverlay(),
      },
      // overlayBuilderMap: {
      //   CharacterBuilder.name: (context, game) => CharacterBuilder(
      //         game: game as Kazoku,
      //       ),
      // },
    ),
  );
}
