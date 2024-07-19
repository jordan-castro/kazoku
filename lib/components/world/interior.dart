import 'dart:async';

import 'package:flame/components.dart';
import 'package:kazoku/components/world/animated_object.dart';
import 'package:kazoku/components/world/object.dart';

/// This component holds everything of a interior.
class InteriorComponent extends Component {
  /// The objects of this interior component.
  List<ObjectComponent> objects = [];

  /// The animated objects of this interior component
  List<AnimatedObjectComponent> animatedObjects = [];

  @override
  FutureOr<void> onLoad() {
  }
}
