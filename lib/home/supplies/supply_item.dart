import 'package:base_app/model/base_app_inventory_item.dart';
import 'package:base_app/model/base_app_parameter.dart';
import 'package:flutter/material.dart';

class SupplyItem extends StatelessWidget {
  const SupplyItem(this.inventory, {super.key, required this.categories});

  final BaseAppInventoryItem inventory;
  final List<BaseAppParameter> categories;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text(
              inventory.itemName,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 20),
            ),
            Row(
              children: [
                Text(
                  '\$${inventory.unitPrice} X ${inventory.quantity} = \$${inventory.totalPrice}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium,
                ),
                Spacer(),
                Row(
                  spacing: 5,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      color: Color(
                        int.parse(
                          BaseAppParameter.findByUuid(categories, inventory.category).paramColor,
                          radix: 16,
                        ),
                      ),
                    ),
                    Text(
                      BaseAppParameter.findByUuid(categories, inventory.category).paramName,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
