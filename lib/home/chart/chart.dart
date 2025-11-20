import 'package:base_app/home/chart/chart_bar.dart';
import 'package:base_app/model/base_app_inventory_item.dart';
import 'package:base_app/model/base_app_parameter.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart(
    this.isLoading, {
    super.key,
    required this.inventoryList,
    required this.categories,
  });

  final bool isLoading;
  final List<BaseAppInventoryItem> inventoryList;
  final List<BaseAppParameter> categories;

  List<BaseAppInventoryBucket> get buckets {
    List<BaseAppInventoryBucket> tempBuckets = [];

    for (final category in categories) {
      tempBuckets.add(
        BaseAppInventoryBucket.forCategory(inventoryList, category),
      );
    }

    return tempBuckets;
  }

  int get maxTotalQty {
    int maxTotalQty = 0;

    for (final bucket in buckets) {
      if (bucket.totalQty > maxTotalQty) {
        maxTotalQty = bucket.totalQty;
      }
    }

    return maxTotalQty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final bucket in buckets) // alternative to map()
                        ChartBar(
                          fill: bucket.totalQty == 0
                              ? 0
                              : bucket.totalQty / maxTotalQty,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: buckets
                      .map(
                        (bucket) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                              width: 24,
                              height: 24,
                              color: Color(
                                int.parse(
                                  bucket.category.paramColor,
                                  radix: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
    );
  }
}
