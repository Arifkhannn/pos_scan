import 'package:shared_preferences/shared_preferences.dart';

Future<String> getAppKey() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? storedAppKey = pref.getString('appKey');
  return storedAppKey ?? 'Empty'; // Default to 'Empty' if not found
}