import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class UniqueCodeManager {
  static const String _uniqueCodeKey = 'unique_code';

  static Future<String> getUniqueCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the unique code already exists
    String? uniqueCode = prefs.getString(_uniqueCodeKey);

    if (uniqueCode == null) {
      uniqueCode = _generateUniqueCode();

      // Save the unique code in SharedPreferences
      await prefs.setString(_uniqueCodeKey, uniqueCode);
    }

    return uniqueCode;
  }

  //  function to generate an  unique code
  static String _generateUniqueCode() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
        12, (_) => characters[random.nextInt(characters.length)]).join();
  }
}
