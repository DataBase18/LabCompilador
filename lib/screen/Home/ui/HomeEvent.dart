
import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:compiladorestareauno/Model/FunctionsVarModel.dart';
import 'package:compiladorestareauno/Model/ProductionModel.dart';
import 'package:compiladorestareauno/mvvm/observer.dart';
import 'package:flutter/material.dart';


class ShowSimpleAlert extends ViewEvent {
  String message;
  Function()? onAccept;

  ShowSimpleAlert(this.message, {this.onAccept}) :super("ShowSimpleAlert");
}

class ChangeLoadingScreen extends ViewEvent {
  bool newState;

  ChangeLoadingScreen(this.newState) :super("ChangeLoadingScreen");
}


class SetVariables extends ViewEvent {
  Set<CompilerVariableModel> rows = {};
  SetVariables({required this.rows}):super("SetVariables");
}



class SetProductions extends ViewEvent {
  Set<ProductionModel> productions;
  SetProductions(this.productions):super("SetProductions");
}


class SetTerminals extends ViewEvent {
  Set<String> terminals;
  SetTerminals(this.terminals):super("SetTerminals");
}



class SetProductionsWithoutRecursive extends ViewEvent {
  Set<ProductionModel> productionsWithoutRecursive;
  SetProductionsWithoutRecursive(this.productionsWithoutRecursive):super("SetProductionsWithoutRecursive");
}



class SetVariablesWithoutRecursion extends ViewEvent {
  Set<CompilerVariableModel> rowsWithoutRecursion = {};
  SetVariablesWithoutRecursion({required this.rowsWithoutRecursion}):super("SetVariablesWithoutRecursion");
}


class SetFirstAndNextFunctions extends ViewEvent {
  Set<FunctionsVarModel> functions;
  SetFirstAndNextFunctions(this.functions):super("SetFirstAndNextFunctions");
}


class SetSymbolTable extends ViewEvent {
  List<List<String>> table;
  SetSymbolTable(this.table):super("SetSymbolTable");
}



class SetNewDramatic extends ViewEvent {
  String dramatic;
  SetNewDramatic(this.dramatic):super("SetNewDramatic");
}
