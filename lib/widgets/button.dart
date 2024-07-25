import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final Color backgroundColor;
  final String text;
  final Color? textColor;
  final double? width;
  final double? borderRadius;

  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.text,
    this.textColor,
    this.width, this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    );
  }
}
