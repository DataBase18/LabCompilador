
import 'dart:ui';

import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:compiladorestareauno/Model/ProductionModel.dart';
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
    return   varsThisProduction.toSet().toList() ;
  }

  List<String> getProductions (String valueProductions) {
    List<String> productionsParts = valueProductions.split("|");
    return productionsParts;
  }

  void compile (String code, List<String> actualTerminals){
    final variablesRegexCompile = RegExp(r"\s*([A-Za-z0-9_]+)\s*=\s*((('([A-Za-z0-9 _]*)')|([A-Za-z0-9_]+))+(\s*\|\s*(('[A-Za-z0-9 _]*')+|([A-Za-z0-9_]+))+)*)");
    Iterable<RegExpMatch> variablesMatches = variablesRegexCompile.allMatches(code);

    String varName ;
    String values ;
    List<CompilerVariableModel> vars = [];
    List<String> terminals = [];
    for(var matches in variablesMatches){
      varName = matches.group(1)??"N/A";
      values = matches.group(2)??"N/A";
      //Val if exits element
      CompilerVariableModel? match = vars.firstWhere(
          (element) => element.varName == varName,
          orElse: () => CompilerVariableModel(varName: "", terminals: [], productions: [])
      );
      if (match.varName.isEmpty){
        vars.add(CompilerVariableModel(
          varName: varName,
          terminals: [],
          productions: getProductions(values)
        ));
      }else {
        int existVarIndex = vars.indexWhere((element) => element.varName == varName ,);
        CompilerVariableModel newValue = vars.elementAt(existVarIndex);
        newValue.productions = [... newValue.productions, ... getProductions(values)];
        vars[existVarIndex] = newValue;
      }
      terminals = [...terminals, ...getIndividualVars(values) ];
    }
    List<ProductionModel> productions = getListProductions(vars);
    notify(SetVariables(rows: vars));
    notify(SetProductions(productions));

    terminals = terminals.toSet().toList();
    notify(SetTerminals(terminals));
  }

  List<ProductionModel> getListProductions (List<CompilerVariableModel> vars){
    List<ProductionModel> productions = [];
    for(CompilerVariableModel currentVar in vars){
      for(String terminalValue in currentVar.productions){
        productions.add(ProductionModel(varName: currentVar.varName, value: terminalValue));
      }
    }
    return productions;
  }


}