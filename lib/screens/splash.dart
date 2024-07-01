import 'package:flutter/material.dart';
import 'package:kazoku/screens/game.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Widget currentWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: currentWidget),
      backgroundColor: Colors.black,
    );
  }

  @override
  void initState() {
    super.initState();
    // Loading state ->

    // 1. Dedication "To Evelyn"
    currentWidget = const Text(
      "To Evelyn",
      style: TextStyle(
        fontSize: 30.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

    // 2. By EpochTech
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      await Future.delayed(
        const Duration(seconds: 1),
      );
      setState(() {
        currentWidget = Text("By EpochTech");
      });
      await Future.delayed(
        const Duration(seconds: 1),
      );
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }
}
