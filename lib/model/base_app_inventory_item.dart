import 'package:base_app/model/base_app_parameter.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();

class BaseAppInventoryItem {
  final String uuid;
  final String itemName;
  final int quantity;
  final double unitPrice;
  final String category;
  final String createdDate;

  BaseAppInventoryItem({
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.category,
  }) : uuid = uid.v4(),
       createdDate = DateTime.now().toIso8601String();

  BaseAppInventoryItem.fromData({
    required this.uuid,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.category,
    required this.createdDate,
  });

  factory BaseAppInventoryItem.fromJson(Map<String, dynamic> json) {
    return BaseAppInventoryItem.fromData(
      uuid: json['uuid'] as String,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      category: json['category'] as String,
      createdDate: json['createdDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'itemName': itemName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'category': category,
      'createdDate': createdDate,
    };
  }

  double get totalPrice {
    return unitPrice * quantity;
  }
}

class BaseAppInventoryBucket {
  const BaseAppInventoryBucket({
    required this.category,
    required this.inventoryList,
  });

  final BaseAppParameter category;
  final List<BaseAppInventoryItem> inventoryList;

  BaseAppInventoryBucket.forCategory(
    List<BaseAppInventoryItem> allInventory,
    this.category,
  ) : inventoryList = allInventory
          .where((inventory) => inventory.category == category.uuid)
          .toList();

  int get totalQty {
    int sum = 0;

    for (final inventory in inventoryList) {
      sum += inventory.quantity;
    }

    return sum;
  }
}
