import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

Vector2 getScreenSizeWithoutContext() {
  // First get the FlutterView.
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

// Dimensions in physical pixels (px)
  Size size = view.physicalSize;
  double width = size.width;
  double height = size.height;

  return Vector2(width, height);
}
