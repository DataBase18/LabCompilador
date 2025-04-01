
import 'dart:convert';

class ProductionModel {
  String varName;
  String value;

  ProductionModel({
    required this.varName,
    required this.value,
  });

  ProductionModel copyWith({
    String? varName,
    String? value,
  }) =>
      ProductionModel(
        varName: varName ?? this.varName,
        value: value ?? this.value,
      );

  factory ProductionModel.fromRawJson(String str) => ProductionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductionModel.fromJson(Map<String, dynamic> json) => ProductionModel(
    varName: json["varName"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "varName": varName,
    "value": value,
  };
}
