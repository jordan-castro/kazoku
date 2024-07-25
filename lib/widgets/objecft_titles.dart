import 'package:flutter/material.dart';

class ObjectTitlesWidget extends StatelessWidget {
  final int type;
  final Function onChange;

  const ObjectTitlesWidget({
    super.key,
    required this.type,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            
          ],
        ),
      ),
    );
  }
}
