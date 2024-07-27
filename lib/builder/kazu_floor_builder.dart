import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku/kazoku.dart';
import 'package:kazoku/widgets/object_headers.dart';
import 'package:kazoku/widgets/object_selector.dart';

class KazuFloorBuilder extends StatefulWidget {
  final Kazoku kazoku;

  const KazuFloorBuilder({super.key, required this.kazoku});

  @override
  State<KazuFloorBuilder> createState() => _KazuFloorBuilderState();
}

class _KazuFloorBuilderState extends State<KazuFloorBuilder> {
  int currentHeaderType = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          ObjectHeadersWidget(
            index: currentHeaderType,
            onChange: (newType) {
              if (newType != currentHeaderType) {
                setState(() => currentHeaderType = newType);
              }
            },
          ),
          ObjectSelectorWidget(
            kazoku: widget.kazoku,
            headerId: currentHeaderType,
          ),
        ],
      ),
    );
  }
}
