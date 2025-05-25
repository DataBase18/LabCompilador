

import 'dart:convert';

import 'package:compiladorestareauno/Model/ProductionModel.dart';

class CompilerVariableModel {
  String varName;
  Set<String> terminals;
  Set<ProductionModel> productions;
  bool isLeftRecursive ;

  CompilerVariableModel({
    required this.varName,
    required this.terminals,
    required this.productions,
    this.isLeftRecursive = false
  });

  CompilerVariableModel copyWith({
    String? varName,
    Set<String>? terminals,
    Set<ProductionModel>? productions,
    bool? isLeftRecursive
  }) =>
      CompilerVariableModel(
        varName: varName ?? this.varName,
        terminals: terminals ?? this.terminals,
        productions: productions ?? this.productions,
        isLeftRecursive: isLeftRecursive ?? this.isLeftRecursive
      );
}
