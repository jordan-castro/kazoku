import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku/widgets/editor_items.dart';

class KazuFloorBuilder extends StatefulWidget {
  const KazuFloorBuilder({super.key});

  @override
  State<KazuFloorBuilder> createState() => _KazuFloorBuilderState();
}

class _KazuFloorBuilderState extends State<KazuFloorBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          ObjectTitlesWidget(),
          ObjectSelectorWidget(),
        ],
      ),
    );
  }
}
