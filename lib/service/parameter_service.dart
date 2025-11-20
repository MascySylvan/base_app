import 'dart:convert';
import 'package:base_app/model/base_app_parameter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var apiUrl = '17bckriqx0.execute-api.ap-southeast-2.amazonaws.com';
var stage = '/prod';
var systemId = 'BASE_APP';

class ParameterService {
  Future<List<BaseAppParameter>?> getParameters({
    required BuildContext context,
    required String paramClass
  }) async {
    final url = Uri.https(
      apiUrl,
      '$stage/params',
      {
        'paramClass': paramClass,
      },
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "system-id": systemId,
      },
    );

    if (!context.mounted) {
      return null;
    }

    if (response.statusCode >= 400) {
      final Map<String, dynamic>? responseBody = jsonDecode(
        response.body,
      );

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Failed to fetch Parameters.',
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

    final List<dynamic> jsonList = json.decode(response.body);

    return jsonList.map((item) => BaseAppParameter.fromJson(item)).toList();
  }

  Future<BaseAppParameter?> saveParameter({
    required BuildContext context,
    required String paramClass,
    required String paramName,
    required String paramColor,
  }) async {
    final uri = Uri.https(
      apiUrl,
      '$stage/params',
    );

    BaseAppParameter newUser = BaseAppParameter(
      paramClass: paramClass,
      paramName: paramName,
      paramColor: paramColor,
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'system-id': systemId,
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
            'Parameter failed to save.',
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

    return newUser;
  }
}
