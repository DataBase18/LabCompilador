
import 'dart:ui';

import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:compiladorestareauno/Model/ProductionModel.dart';
import 'package:compiladorestareauno/core/GlobalConstants.dart';
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
    final subRegex = RegExp(r"('(.*)')");
    Iterable<RegExpMatch> individualVars = subRegex.allMatches(valueProduction);
    List<String> varsThisProduction = [];
    for (var subMatch in individualVars){
      varsThisProduction.add(subMatch[2]??"");
    }
    return   varsThisProduction.toSet().toList() ;
  }

  List<String> getProductions (String valueProductions) {
    List<String> productionsParts = valueProductions.split("|");
    return productionsParts;
  }

  void compile (String code, List<String> actualTerminals){
    //final variablesRegexCompile = RegExp(r"\s*([A-Za-z0-9_]+)\s*=\s*((('([A-Za-z0-9 _]*)')|([A-Za-z0-9_]+))+(\s*\|\s*(('[A-Za-z0-9 _]*')+|([A-Za-z0-9_]+))+)*)");
    final variablesRegexCompile = RegExp(        r"\s*(.*)\s*=\s*((('.*')|(.+))+(\s*\|\s*(('.*')+|(.+))+)*)"              );
    Iterable<RegExpMatch> variablesMatches = variablesRegexCompile.allMatches(code);

    String varName ;
    String values ;

    List<CompilerVariableModel> vars = []; //Variables
    List<String> terminals = [];  //Terminals
    List<ProductionModel> productions =[]; //Productions
    List<ProductionModel> productionsWithoutRecursive =[]; //Productions
    List<ProductionModel> productionsWithoutSeparation = []; //Productions to one linea, not division from "a | b"


    //Normal productions
    for(var matches in variablesMatches){
      varName = matches.group(1)??"N/A";
      values = matches.group(2)??"N/A";

      //Val if exits element
      CompilerVariableModel? match = vars.firstWhere(
          (element) => element.varName == varName,
          orElse: () => CompilerVariableModel(varName: "", terminals: [], productions: [])
      );
      if (match.varName.isEmpty){ //Not exists element in list
        vars.add(CompilerVariableModel(
          varName: varName,
          terminals: [],
          productions: getProductions(values)
        ));
      }else { // exists element, update values
        int existVarIndex = vars.indexWhere((element) => element.varName == varName ,);
        CompilerVariableModel newValue = vars.elementAt(existVarIndex);
        newValue.productions = [... newValue.productions, ... getProductions(values)];
        vars[existVarIndex] = newValue;
      }
      terminals = [...terminals, ...getIndividualVars(values) ];

      //Add single productions
      productionsWithoutSeparation.add(ProductionModel(varName: varName, value: values));
    }


    productions = getListProductions(vars);
    productionsWithoutRecursive=getProductionsWithoutRecursive(productionsWithoutSeparation);
    terminals = terminals.toSet().toList();

    notify(SetVariables(rows: vars));
    notify(SetProductions(productions));
    notify(SetProductionsWithoutRecursive(productionsWithoutRecursive));
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

  List<ProductionModel> getProductionsWithoutRecursive (List<ProductionModel> productionsFromOneLine){
    List<ProductionModel> productionsWithoutRecursive= [];
    List<ProductionModel> productionsWithoutRecursiveInOneLine = [];
    for (ProductionModel production in productionsFromOneLine){
      String varName = production.varName;
      int varNameLength = varName.length;

      //Get productions this line
      List<String> subProductions = getProductions(production.value);

      String firstElement = subProductions.elementAt(0);
      String firstValueElementValidation = firstElement.substring(0,varNameLength);

      if(firstValueElementValidation == varName){//Its left recursive
        //Creating alpha value
        String alphaValue =  firstElement.substring(varNameLength,  firstElement.length);

        //Creating A' (A1 for this course)
        String nameA1Var = "${varName}1";
        ProductionModel productionA1 = ProductionModel(
          varName: nameA1Var,
          value:   "$alphaValue$nameA1Var|${GlobalConstants.epsilonSymbol}"
        );

        //Creating productions with modifications
        List<String> productionsWithBetaIncluded = createBA1ValuesInProductions(subProductions, nameA1Var);

        //Creating new value to var A
        String valuesToNewA="";
        for(String productionWithBetaIncluded in productionsWithBetaIncluded){
          if(valuesToNewA.isNotEmpty){
            valuesToNewA="$valuesToNewA|$productionWithBetaIncluded";
          }else{
            valuesToNewA=productionWithBetaIncluded;
          }
        }
        ProductionModel newA = ProductionModel(
            varName: varName,
            value:  valuesToNewA
        );

        //Add to final list, in new productions
        productionsWithoutRecursiveInOneLine.add(newA);
        productionsWithoutRecursiveInOneLine.add(productionA1);
      }else{
        productionsWithoutRecursiveInOneLine.add(production);
      }
    }

    //Separate productions to one one
    for(ProductionModel prod in productionsWithoutRecursiveInOneLine){
      List<String> productions = getProductions(prod.value);
      for(String  productionOneToOne in productions){
        ProductionModel finalProd = ProductionModel(
            varName: prod.varName,
            value:  productionOneToOne
        );
        productionsWithoutRecursive.add(finalProd);
      }
    }

    return productionsWithoutRecursive;
  }

  List<String> createBA1ValuesInProductions (List<String> subProductions, String varNameA1){
    List<String> productionsWithBetaIncluded =[];
    for(int i = 1; i< subProductions.length; i++){
      productionsWithBetaIncluded.add ("${subProductions.elementAt(i)}$varNameA1");
    }
    return productionsWithBetaIncluded;
  }
}