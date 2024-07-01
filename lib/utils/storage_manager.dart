import 'package:shared_preferences/shared_preferences.dart';

// Mira a https://stackoverflow.com/questions/60232070/how-to-implement-dark-mode-in-flutter.

/// Controla facil a grabar y guardar shared preferences.
class StorageManager {
  /// Guarda algo en shared preferences.
  ///
  /// **Argumentors**
  /// - `String key` la llave uniquo de el [value].
  /// - `dynamic value` qualckier mierda.
  /// - `bool? {tira}` si deberia tirar un error si el [value] es invalido.
  static void saveData(String key, dynamic value, {bool? tira}) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      // Si tira es true entonces tira error
      if (tira == true) {
        throw (Exception("Tipo invalido: ${value.runtimeType}"));
      }
    }
  }

  /// Lea la data.
  /// 
  /// **Argumentos**
  /// - `String key` la llave uniquo de la data.
  /// 
  /// **Return** `dynamic` Null si no lo encuentra. 
  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  /// Remova la data por la llave.
  /// 
  /// **Argumentos**
  /// - `String key` la llave uniquo de la data.
  static deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}