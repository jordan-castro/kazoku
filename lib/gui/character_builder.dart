import 'package:flutter/material.dart';
import 'package:kazoku/kazoku.dart';

class CharacterBuilder extends StatefulWidget {
  static const name = "CharacterBuilder";

  final Kazoku game;

  const CharacterBuilder({super.key, required this.game});

  @override
  State<CharacterBuilder> createState() => _CharacterBuilderState();
}

class _CharacterBuilderState extends State<CharacterBuilder> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.all(
          20.0,
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 22, 82, 185),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Kazoku - Create your character",
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Create"),
            )
          ],
        ),
      ),
      // child: Stack(
      //   children: [
      //     // Image.asset(
      //     //   "assets/images/ui/button_square_border.png",
      //     //   width: size.width,
      //     //   height: size.height,
      //     //   fit: BoxFit.fill,
      //     //   filterQuality: FilterQuality.high,
      //     // ),
      //   ],
      // ),
    );
  }
}
