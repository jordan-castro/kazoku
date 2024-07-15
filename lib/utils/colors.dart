import 'dart:math';

/// Convert a hex code into it's RGB equivalent.
List<int> hexToRgb(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length != 6) {
    throw ArgumentError('Invalid hex color format');
  }
  int r = int.parse(hex.substring(0, 2), radix: 16);
  int g = int.parse(hex.substring(2, 4), radix: 16);
  int b = int.parse(hex.substring(4, 6), radix: 16);
  return [r, g, b];
}

/// Check if 2 hexidecimal colors match.
bool isMatching(String color1, String color2, {double threshold = 100.0}) {
  List<int> rgb1 = hexToRgb(color1);
  List<int> rgb2 = hexToRgb(color2);

  // Calculate Euclidean distance between the two colors
  double distance = sqrt(pow(rgb1[0] - rgb2[0], 2) +
      pow(rgb1[1] - rgb2[1], 2) +
      pow(rgb1[2] - rgb2[2], 2));

  // Check if the distance is within the threshold
  return distance < threshold;
}

/// Helper function to convert a rgb to hex.
String rgbToHex(int r, int g, int b) {
  return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
}
