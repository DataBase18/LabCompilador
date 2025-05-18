
import 'dart:convert';

class FunctionsVarModel {
  String varName;
  List<String> firstFunction;
  String firstFunctionInOneLine;
  List<String> nextFunction;
  String nextFunctionInOneLine;

  FunctionsVarModel({
    required this.varName,
    required this.firstFunction,
    required this.nextFunction,
    this.firstFunctionInOneLine ="",
    this.nextFunctionInOneLine ="",
  });

  FunctionsVarModel copyWith({
    String? varName,
    List<String>? firstFunction,
    List<String>? nextFunction,
    String? nextFunctionInOneLine,
    String? firstFunctionInOneLine,
  }) =>
      FunctionsVarModel(
        varName: varName ?? this.varName,
        firstFunction: firstFunction ?? this.firstFunction,
        nextFunction: nextFunction ?? this.nextFunction,
        firstFunctionInOneLine: firstFunctionInOneLine ?? this.nextFunctionInOneLine,
        nextFunctionInOneLine: nextFunctionInOneLine ?? this.nextFunctionInOneLine
      );

  factory FunctionsVarModel.fromRawJson(String str) =>
      FunctionsVarModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FunctionsVarModel.fromJson(Map<String, dynamic> json) =>
      FunctionsVarModel(
        varName: json["varName"],
        firstFunction: List<String>.from(json["firstFunction"].map((x) => x)),
        nextFunction: List<String>.from(json["nextFunction"].map((x) => x)),
        nextFunctionInOneLine: "",
        firstFunctionInOneLine: ""
      );

  Map<String, dynamic> toJson() => {
    "varName": varName,
    "firstFunction": List<dynamic>.from(firstFunction.map((x) => x)),
    "nextFunction": List<dynamic>.from(nextFunction.map((x) => x)),
  };
}
