import 'dart:async';

import 'package:flame/components.dart';
import 'package:kazoku/components/kazu_floor/object.dart';
import 'package:kazoku/components/kazu_floor/objects/floor.dart';
import 'package:kazoku/utils/json.dart';

/// This component holds everything of a KazuFloor.
class KazuFloorComponent extends Component {
  final JSON map;
  final int id;
  final String floorNumber;
  final String name;

  late Floor floor;

  /// The objects of this interior component.
  List<ObjectComponent> objects = [];

  /// The animated objects of this interior component
  List<AnimatedObjectComponent> animatedObjects = [];

  KazuFloorComponent({
    super.children,
    super.priority,
    super.key,
    required this.map,
    required this.id,
    required this.floorNumber,
    required this.name,
  });

  @override
  FutureOr<void> onLoad() {
    // Load the floor
    floor = Floor(
      tiles: map['layers']['0'],
    );
    add(floor);
  }
}
