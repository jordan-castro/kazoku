import 'package:flutter/material.dart';
import 'package:kazoku/builder/kazu_floor_builder.dart';
import 'package:kazoku/kazoku.dart';

/// This overlay only exists to show the kazufloor builder.
class RoomEditorOverlay extends StatelessWidget {
  static String overlay = "roomEditorOverlay";

  final Kazoku kazoku;
  const RoomEditorOverlay({
    super.key,
    required this.kazoku,
  });

  @override
  Widget build(BuildContext context) {
    return KazuFloorBuilder(
      kazoku: kazoku,
    );
  }
}
