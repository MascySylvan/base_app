import 'package:base_app/home/supplies/supply_item.dart';
import 'package:base_app/model/base_app_inventory_item.dart';
import 'package:base_app/model/base_app_parameter.dart';
import 'package:flutter/material.dart';

class SuppliesList extends StatelessWidget {
  const SuppliesList({
    super.key,
    required this.inventoryList,
    required this.categories,
  });

  final List<BaseAppInventoryItem> inventoryList;
  final List<BaseAppParameter> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: inventoryList.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.2),
          margin: Theme.of(context).cardTheme.margin,
        ),
        key: ValueKey(inventoryList[index]),
        onDismissed: (direction) {},
        child: SupplyItem(
          inventoryList[index],
          categories: categories,
        ),
      ),
    );
  }
}
