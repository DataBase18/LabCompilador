

import 'dart:convert';

class CompilerVariableModel {
  String varName;
  List<String> terminals;

  CompilerVariableModel({
    required this.varName,
    required this.terminals,
  });

  CompilerVariableModel copyWith({
    String? varName,
    List<String>? terminals,
  }) =>
      CompilerVariableModel(
        varName: varName ?? this.varName,
        terminals: terminals ?? this.terminals,
      );

  factory CompilerVariableModel.fromRawJson(String str) => CompilerVariableModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompilerVariableModel.fromJson(Map<String, dynamic> json) => CompilerVariableModel(
    varName: json["varName"],
    terminals: List<String>.from(json["terminals"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "varName": varName,
    "terminals": List<dynamic>.from(terminals.map((x) => x)),
  };
}
