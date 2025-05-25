
import 'dart:convert';

class ProductionModel {
  String varName;
  String value;
  List<String> elements;
  ProductionModel({
    required this.varName,
    required this.value,
    required this.elements
  });

  ProductionModel copyWith({
    String? varName,
    String? value,
    List<String> ? elements,
  }) =>
      ProductionModel(
        varName: varName ?? this.varName,
        value: value ?? this.value,
        elements: elements??this.elements
      );

}
