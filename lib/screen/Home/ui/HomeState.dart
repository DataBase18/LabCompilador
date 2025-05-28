import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:compiladorestareauno/Model/FunctionsVarModel.dart';
import 'package:compiladorestareauno/Model/ProductionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeState {
  bool loadingScreen = false;

  TextEditingController inputCode = TextEditingController();
  TextEditingController inputNewDramatic = TextEditingController();

  Set<CompilerVariableModel> vars = {};
  Set<ProductionModel> productions = {};
  Set<String> terminals = {};
  ScrollController scrollController =  ScrollController();

  Set<ProductionModel> productionsWithoutRecursion = {};
  Set<CompilerVariableModel> varsWithoutRecursion = {};

  Set<FunctionsVarModel> functions ={};
  List<List<String>> symbolTable = [];
}