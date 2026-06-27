import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:base_app/model/base_app_inventory_item.dart';
import 'package:base_app/config/app_config.dart';

class InventoryService {
  Future<List<BaseAppInventoryItem>?> getInventory({
    required BuildContext context,
  }) async {
    final url = Uri.https(AppConfig.apiUrl, '${AppConfig.stage}/inventory');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "system-id": AppConfig.systemId,
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
            'Failed to fetch Inventory.',
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

    return jsonList.map((item) => BaseAppInventoryItem.fromJson(item)).toList();
  }

  Future<String?> save({
    required BuildContext context,
    required String itemName,
    required int quantity,
    required double unitPrice,
    required String category,
  }) async {
    final uri = Uri.https(
      AppConfig.apiUrl,
      '${AppConfig.stage}/inventory',
    );

    BaseAppInventoryItem newSupply = BaseAppInventoryItem(
      itemName: itemName,
      quantity: quantity,
      unitPrice: unitPrice,
      category: category,
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'system-id': AppConfig.systemId,
      },
      body: json.encode(newSupply.toJson()),
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
            'Supply failed to register.',
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
