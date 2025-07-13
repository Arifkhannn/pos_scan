import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String globalAppKey = '';

class Login {
  Future<int> loginUser(
    String phone,
    String password,
  ) async {
    final url = Uri.parse('https://pos.dftech.in/application-login');
    //final Map<String, String> bodye = {'phone': phone, 'password': password};
    try {
      final loginResponse =
          await http.post(url, body: {'phone': phone, 'password': password});
      print(loginResponse.statusCode);
      if (loginResponse.statusCode == 200) {
        final responseBody = json.decode(loginResponse.body);
        if (responseBody['status'] == true && responseBody['appKey'] != null) {
          globalAppKey = responseBody['appKey'];
           if (globalAppKey.isEmpty) {
          globalAppKey = '';
        }
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('appKey', globalAppKey);
         
        }

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setInt('login_value', 1);
        print(loginResponse.body);
        return 200;
      } else {
        print(loginResponse.body);
        print(
            'there is somoe error login .....this is from else from try block');
        return loginResponse.statusCode;
      }
    } catch (e) {
      print(e);
      return 109;
    }
  }
}
