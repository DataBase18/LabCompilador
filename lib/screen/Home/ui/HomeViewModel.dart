
import 'dart:ui';

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

  void compile (String code){

    List<DataRow> varsList = [];

    final variablesRegexCompile = RegExp(r"\s*([A-Za-z0-9_]+)\s*=\s*((([A-Za-z0-9_]+)|('(.*)'))(\s*\|\s*(([A-Za-z0-9_]+)|('(.*)')))*)");
    Iterable<RegExpMatch> variablesMatches = variablesRegexCompile.allMatches(code);

    String varName ;
    String values ;
    for(var matches in variablesMatches){
      varName = matches.group(1)??"N/A";
      values = matches.group(2)??"N/A";
      varsList.add(
          DataRow(
              cells: [  DataCell(Text(varName)), DataCell(Text(values))  ]
          )
      );
      ///REVIEW IMPLEMENTATION
      //Ger  variables with other regex
      // RegExp regexVars = RegExp(r"(\s*'(.*)'\s*)|(\s*([A-Za-z0-9_]+)\s*)");
      // Iterable<RegExpMatch> varsValues = regexVars.allMatches(values);
      // for(var value in varsValues){
      // }
      //
    }

    notify(SetVariables(rows: varsList));
  }

}