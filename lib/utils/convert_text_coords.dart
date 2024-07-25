import 'package:flame/components.dart';

/// Convert a text of "1,2;3,3" into  [Vector2(1,2),Vector2(3,3)]
List<Vector2> convertTextCoords(String textCoords) {
  return textCoords.split(";").map((el) => _convert(el)).toList();
}

Vector2 _convert(String split) {
  final nums =
      split.split(",").map((element) => double.tryParse(element)).toList();
  
  // Ensure nums has exactly two elements
  if (nums.length != 2 || nums.contains(null)) {
    throw ArgumentError('Invalid coordinate format: $split');
  }
  
  return Vector2(nums[0]!, nums[1]!);
}
