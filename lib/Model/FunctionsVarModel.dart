
import 'dart:convert';

class FunctionsVarModel {
  String varName;
  Set<String> firstFunction;
  String firstFunctionInOneLine;
  Set<String> nextFunction;
  String nextFunctionInOneLine;
  Set<String> productionsInTableSymbols;

  FunctionsVarModel({
    required this.varName,
    required this.firstFunction,
    required this.nextFunction,
    this.firstFunctionInOneLine ="",
    this.nextFunctionInOneLine ="",
    required this.productionsInTableSymbols,
  });

  FunctionsVarModel copyWith({
    String? varName,
    Set<String>? firstFunction,
    Set<String>? nextFunction,
    String? nextFunctionInOneLine,
    String? firstFunctionInOneLine,
    Set<String>? productionsInTableSymbols
  }) =>
      FunctionsVarModel(
        varName: varName ?? this.varName,
        firstFunction: firstFunction ?? this.firstFunction,
        nextFunction: nextFunction ?? this.nextFunction,
        firstFunctionInOneLine: firstFunctionInOneLine ?? this.nextFunctionInOneLine,
        nextFunctionInOneLine: nextFunctionInOneLine ?? this.nextFunctionInOneLine,
        productionsInTableSymbols:  productionsInTableSymbols  ?? this.productionsInTableSymbols
      );

  factory FunctionsVarModel.fromRawJson(String str) =>
      FunctionsVarModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FunctionsVarModel.fromJson(Map<String, dynamic> json) =>
      FunctionsVarModel(
        varName: json["varName"],
        firstFunction: Set<String>.from(json["firstFunction"].map((x) => x)),
        nextFunction: Set<String>.from(json["nextFunction"].map((x) => x)),
        nextFunctionInOneLine: "",
        firstFunctionInOneLine: "",
        productionsInTableSymbols: {}
      );

  Map<String, dynamic> toJson() => {
    "varName": varName,
    "firstFunction": Set<dynamic>.from(firstFunction.map((x) => x)),
    "nextFunction": Set<dynamic>.from(nextFunction.map((x) => x)),
  };
}
