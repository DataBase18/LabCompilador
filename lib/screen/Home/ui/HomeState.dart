import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:compiladorestareauno/Model/FunctionsVarModel.dart';
import 'package:compiladorestareauno/Model/ProductionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeState {
  bool loadingScreen = false;

  TextEditingController inputCode = TextEditingController();

  List<CompilerVariableModel> vars = [];
  List<ProductionModel> productions = [];
  List<String> terminals = [];


  List<ProductionModel> productionsWithoutRecursion = [];
  List<CompilerVariableModel> varsWithoutRecursion = [];

  List<FunctionsVarModel> functions =[];
}