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
}
