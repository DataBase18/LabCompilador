
import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
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
  List<CompilerVariableModel> rows = [];
  SetVariables({required this.rows}):super("SetVariables");
}



class SetProductions extends ViewEvent {
  List<ProductionModel> productions;
  SetProductions(this.productions):super("SetProductions");
}


class SetTerminals extends ViewEvent {
  List<String> terminals;
  SetTerminals(this.terminals):super("SetTerminals");
}



class SetProductionsWithoutRecursive extends ViewEvent {
  List<ProductionModel> productionsWithoutRecursive;
  SetProductionsWithoutRecursive(this.productionsWithoutRecursive):super("SetProductionsWithoutRecursive");
}



class SetVariablesWithoutRecursion extends ViewEvent {
  List<CompilerVariableModel> rowsWithoutRecursion = [];
  SetVariablesWithoutRecursion({required this.rowsWithoutRecursion}):super("SetVariablesWithoutRecursion");
}
