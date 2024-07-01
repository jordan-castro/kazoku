import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:kazoku/kazoku.dart';
import 'package:kazoku/screens/game.dart';
import 'package:kazoku/screens/splash.dart';

void main() {
  print("Kazoku Start");
  runApp(const KazokuApp());
}

class KazokuApp extends StatelessWidget {
  const KazokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        GameScreen.routeName: (context) => const GameScreen(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
