import 'package:uuid/uuid.dart';

const uid = Uuid();

class BaseAppParameter {
  final String uuid;
  final String paramClass;
  final String paramName;
  final String paramColor;

  BaseAppParameter({
    required this.paramClass,
    required this.paramName,
    required this.paramColor,
  }) : uuid = uid.v4();

  BaseAppParameter.fromData({
    required this.uuid,
    required this.paramClass,
    required this.paramName,
    required this.paramColor,
  });

  factory BaseAppParameter.fromJson(Map<String, dynamic> json) {
    return BaseAppParameter.fromData(
      uuid: json['uuid'] as String,
      paramClass: json['paramClass'] as String,
      paramName: json['paramName'] as String,
      paramColor: json['paramColor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'paramClass': paramClass,
      'paramName': paramName,
      'paramColor': paramColor,
    };
  }

  factory BaseAppParameter.findByUuid(List<BaseAppParameter> categories, String uuid) {
    return categories.where((param) => param.uuid == uuid).first;
  }
}
