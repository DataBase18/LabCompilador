import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeState {
  bool loadingScreen = false;

  TextEditingController inputCode = TextEditingController();

  List<CompilerVariableModel> vars = [];
}