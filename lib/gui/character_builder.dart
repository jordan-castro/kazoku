import 'package:flutter/material.dart';
import 'package:kazoku/kazoku.dart';

class CharacterBuilder extends StatefulWidget {
  final Kazoku game;

  const CharacterBuilder({super.key, required this.game});

  @override
  State<CharacterBuilder> createState() => _CharacterBuilderState();
}

class _CharacterBuilderState extends State<CharacterBuilder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {},
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/ui/button_square_border.png",
                    width: 100,
                    height: 50,
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text("Body Type"),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
