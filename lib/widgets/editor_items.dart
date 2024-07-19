import 'package:flutter/material.dart';

class EditorItemsWidget extends StatefulWidget {
  const EditorItemsWidget({super.key});

  @override
  State<EditorItemsWidget> createState() => _EditorItemsWidgetState();
}

class _EditorItemsWidgetState extends State<EditorItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[200],
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              print("presed");
            },
            child: Text("Nigga"),
          )
        ],
      ),
    );
  }
}
