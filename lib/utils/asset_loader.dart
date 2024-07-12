// Because I am tired of working with flames bullshit asset loader.
import 'package:flutter/services.dart' show rootBundle;

/// Load a asset which is a fancy string.
///
/// - This can be a JSON file
/// - This can be a text file
/// - This can be any file that is plain text.
Future<String> loadStringAsset(String assetPath) async {
  return await rootBundle.loadString(assetPath);
}