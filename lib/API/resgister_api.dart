import 'dart:convert';

import 'package:http/http.dart' as http;

class Resgister {
  Future<int> registerUser(
      String phone, String password, ) async {
    final url = Uri.parse('https://pos.dftech.in/register-application');
    //final Map<String, String> bodye = {'phone': phone, 'password': password};
    try {
      final registerResponse = await http.post(url,
          headers: {'Authorization-key': 'not sent yet'}, body: {
            'phone':phone,
            'password':password
          });
      print(registerResponse.statusCode);
      if (registerResponse.statusCode == 200) {
        print(registerResponse.body);
        return 200;
      } else {
        print(registerResponse.body);
        print('there is somoe error .....this is from else from try block');
        return registerResponse.statusCode;
      }
    } catch (e) {
      print(e);
      return 109;
    }
  }
}
