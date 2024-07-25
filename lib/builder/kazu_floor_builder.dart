import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku/widgets/editor_items.dart';
import 'package:kazoku/widgets/object_headers.dart';

class KazuFloorBuilder extends StatefulWidget {
  const KazuFloorBuilder({super.key});

  @override
  State<KazuFloorBuilder> createState() => _KazuFloorBuilderState();
}

class _KazuFloorBuilderState extends State<KazuFloorBuilder> {
  int currentHeaderType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ObjectHeadersWidget(
            index: currentHeaderType,
            onChange: (newType) {
              setState(() => currentHeaderType = newType);
            },
          ),
          // ObjectSelectorWidget(),
        ],
      ),
    );
  }
}
