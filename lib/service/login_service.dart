import 'package:http/http.dart' as http;

class LoginService {
  void loginRequest({required String username, required String password}) async {
    final uri = Uri.https(
      'q8joilyc5c.execute-api.ap-southeast-2.amazonaws.com/prod',
      '/login',
      {
        'username': username.trim(),
        'password': password.trim(),
      },
    );

    final response = await http.get(uri);
    print(response);
  }
}
