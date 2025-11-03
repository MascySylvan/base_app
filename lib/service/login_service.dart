import 'dart:convert';

import 'package:base_app/model/base_app_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var apiUrl = '17bckriqx0.execute-api.ap-southeast-2.amazonaws.com';
var stage = '/prod';

class LoginService {
  Future<BaseAppUser?> loginRequest({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    final uri = Uri.https(
      apiUrl,
      '$stage/login',
      {
        'username': username.trim(),
        'password': password.trim(),
      },
    );

    final response = await http.get(uri);

    if (!context.mounted) {
      return null;
    }

    final Map<String, dynamic>? responseBody = jsonDecode(
      response.body,
    );

    if (response.statusCode >= 400) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Login failed.',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            responseBody != null
                ? responseBody['message']
                : 'Internal Server Error',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );

      return null;
    }

    BaseAppUser loginUser = BaseAppUser.fromJson(responseBody!['data']);
    return loginUser;
  }

  Future<String?> register({
    required BuildContext context,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final uri = Uri.https(
      apiUrl,
      '$stage/register',
    );

    BaseAppUser newUser = BaseAppUser(
      username: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(newUser.toJson()),
    );

    if (!context.mounted) {
      return null;
    }

    final Map<String, dynamic>? responseBody = jsonDecode(
      response.body,
    );

    if (response.statusCode >= 400) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Registration failed.',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            responseBody != null
                ? responseBody['message']
                : 'Internal Server Error',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );

      return null;
    }

    return responseBody!['message'];
  }
}
