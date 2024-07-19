import 'package:flutter/material.dart';
import 'package:kazoku/widgets/editor_items.dart';

class RoomEditorOverlay extends StatelessWidget {
  static String overlay = "roomEditorOverlay";
  const RoomEditorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Spacer(),
          EditorItemsWidget(),
        ],
      ),
    );
  }
}
