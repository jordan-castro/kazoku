import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:kazoku/kazoku.dart';

void main() {
  print("Kazoku Start");
  runApp(
    GameWidget(
      game: Kazoku(),
    ),
  );
}