import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:compiladorestareauno/Model/FunctionsVarModel.dart';
import 'package:compiladorestareauno/Model/ProductionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeState {
  bool loadingScreen = false;

  TextEditingController inputCode = TextEditingController();

  Set<CompilerVariableModel> vars = {};
  Set<ProductionModel> productions = {};
  Set<String> terminals = {};


  Set<ProductionModel> productionsWithoutRecursion = {};
  Set<CompilerVariableModel> varsWithoutRecursion = {};

  Set<FunctionsVarModel> functions ={};
}