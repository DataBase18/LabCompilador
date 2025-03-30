
import 'dart:ui';

import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:compiladorestareauno/mvvm/viewModel.dart';
import 'package:compiladorestareauno/screen/Home/domain/HomeRepository.dart';
import 'package:compiladorestareauno/screen/Home/ui/HomeEvent.dart';
import 'package:flutter/material.dart';


class HomeViewModel extends EventViewModel {
  HomeRepository repository;

  HomeViewModel(this.repository);

  void changeLoadingScreen(bool newState) {
    notify(ChangeLoadingScreen(newState));
  }


  List<String> getIndividualVars (String valueProduction, ){
    //Find the sub vars
    final subRegex = RegExp(r"('([A-Za-z0-9 _]*)')");
    Iterable<RegExpMatch> individualVars = subRegex.allMatches(valueProduction);
    List<String> varsThisProduction = [];
    for (var subMatch in individualVars){
      varsThisProduction.add(subMatch[1]??"");
    }
    return varsThisProduction;
  }

  void compile (String code){

    List<DataRow> varsList = [];

    final variablesRegexCompile = RegExp(r"\s*([A-Za-z0-9_]+)\s*=\s*(('([A-Za-z0-9 _]*)')+(\s*\|\s*('([A-Za-z0-9 _]*)')+)*)");
    Iterable<RegExpMatch> variablesMatches = variablesRegexCompile.allMatches(code);

    String varName ;
    String values ;

    List<CompilerVariableModel> vars = [];

    for(var matches in variablesMatches){
      varName = matches.group(1)??"N/A";
      values = matches.group(2)??"N/A";

      //Val if exits element
      CompilerVariableModel? match = vars.firstWhere(
          (element) => element.varName == varName,
          orElse: () => CompilerVariableModel(varName: "", terminals: [])
      );
      if (match.varName.isEmpty){
        vars.add(CompilerVariableModel(
          varName: varName,
          terminals: getIndividualVars(values)
        ));
      }else {
        int existVarIndex = vars.indexWhere((element) => element.varName == varName ,);
        CompilerVariableModel newValue = vars.elementAt(existVarIndex);
        newValue.terminals = [...newValue.terminals, ...getIndividualVars(values)];
        vars[existVarIndex] = newValue;
      }
    }

    for (var varCompiled in vars) {
      varsList.add(
          DataRow(
              cells: [  DataCell(Text(varCompiled.varName)), DataCell(Text(varCompiled.terminals.toString()))  ]
          )
      );
    }

    notify(SetVariables(rows: varsList));
  }

}