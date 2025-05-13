
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


  List<String> getTerminalsFromOneLineStr(String valueProduction,) {
    //Find the sub vars
    final subRegex = RegExp(r"('([^']+)')");
    Iterable<RegExpMatch> individualVars = subRegex.allMatches(valueProduction);
    List<String> varsThisProduction = [];
    for (var subMatch in individualVars) {
      varsThisProduction.add(subMatch[2] ?? "");
    }
    return varsThisProduction.toSet().toList();
  }

  List<String> getProductionsFromOneLineStr(String valueProductions) {
    List<String> productionsParts = valueProductions.split("|");
    return productionsParts;
  }

  List<ProductionModel> getListProductionsFromCompilerVariableList(
      List<CompilerVariableModel> vars) {
    List<ProductionModel> productions = [];
    for (CompilerVariableModel currentVar in vars) {
      for (String production in currentVar.productions) {
        productions.add(
            ProductionModel(varName: currentVar.varName, value: production));
      }
    }
    return productions;
  }

  List<String> getTerminalsFromCompilerVariableList(List<CompilerVariableModel> vars) {
    List<String> terminals = [];
    for (CompilerVariableModel currentVar in vars) {
      for (String production in currentVar.productions) {
        terminals = [... terminals, ... getTerminalsFromOneLineStr(production)];
      }
    }
    return terminals;
  }

  List<String> createBA1ValuesInProductions(List<String> subProductions,
      String varNameA1) {
    List<String> productionsWithBetaIncluded = [];
    for (int i = 1; i < subProductions.length; i++) {
      productionsWithBetaIncluded.add(
          "${subProductions.elementAt(i)}$varNameA1");
    }
    return productionsWithBetaIncluded;
  }


  List<ProductionModel> getProductionsFromOneLineStrWithoutRecursive(
      List<ProductionModel> productionsFromOneLine) {
    List<ProductionModel> productionsWithoutRecursive = [];
    List<ProductionModel> productionsWithoutRecursiveInOneLine = [];
    for (ProductionModel production in productionsFromOneLine) {
      String varName = production.varName;
      int varNameLength = varName.length;

      //Get productions this line
      List<String> subProductions = getProductionsFromOneLineStr(
          production.value);

      String firstElement = subProductions.elementAt(0);
      String firstValueElementValidation = firstElement.substring(
          0, varNameLength);

      if (firstValueElementValidation == varName) { //Its left recursive
        //Creating alpha value
        String alphaValue = firstElement.substring(
            varNameLength, firstElement.length);

        //Creating A' (A1 for this course)
        String nameA1Var = "${varName}1";
        ProductionModel productionA1 = ProductionModel(
            varName: nameA1Var,
            value: "$alphaValue$nameA1Var|${GlobalConstants.epsilonSymbol}"
        );

        //Creating productions with modifications
        List<String> productionsWithBetaIncluded = createBA1ValuesInProductions(
            subProductions, nameA1Var);

        //Creating new value to var A
        String valuesToNewA = "";
        for (String productionWithBetaIncluded in productionsWithBetaIncluded) {
          if (valuesToNewA.isNotEmpty) {
            valuesToNewA = "$valuesToNewA|$productionWithBetaIncluded";
          } else {
            valuesToNewA = productionWithBetaIncluded;
          }
        }
        ProductionModel newA = ProductionModel(
            varName: varName,
            value: valuesToNewA
        );

        //Add to final list, in new productions
        productionsWithoutRecursiveInOneLine.add(newA);
        productionsWithoutRecursiveInOneLine.add(productionA1);
      } else {
        productionsWithoutRecursiveInOneLine.add(production);
      }
    }

    //Separate productions to one one
    for (ProductionModel prod in productionsWithoutRecursiveInOneLine) {
      List<String> productions = getProductionsFromOneLineStr(prod.value);
      for (String productionOneToOne in productions) {
        ProductionModel finalProd = ProductionModel(
            varName: prod.varName,
            value: productionOneToOne
        );
        productionsWithoutRecursive.add(finalProd);
      }
    }

    return productionsWithoutRecursive;
  }


  void compile(String code, List<String> actualTerminals) {
    //final variablesRegexCompile = RegExp(r"\s*([A-Za-z0-9_]+)\s*=\s*((('([A-Za-z0-9 _]*)')|([A-Za-z0-9_]+))+(\s*\|\s*(('[A-Za-z0-9 _]*')+|([A-Za-z0-9_]+))+)*)");
    final variablesRegexCompile = RegExp(
        r"\s*(.*)\s*=\s*((('.*')|(.+))+(\s*\|\s*(('.*')+|(.+))+)*)");
    Iterable<RegExpMatch> variablesMatches = variablesRegexCompile.allMatches(
        code);

    String varName;
    String values;

    List<CompilerVariableModel> vars = []; //Variables
    List<String> terminals = []; //Terminals
    List<ProductionModel> productions = []; //Productions

    List<CompilerVariableModel> varsWithoutRecursion = []; //Variables
    List<ProductionModel> productionsWithoutRecursion = []; //Productions
    List<String> terminalsWithoutRecursion = [
    ]; //Productions to one linea, not division from "a | b"


    //Normal productions
    for (var matches in variablesMatches) {
      varName = matches.group(1) ?? "N/A";
      values = matches.group(2) ?? "N/A";

      ///Global
      List<String> productionsForThisLine = getProductionsFromOneLineStr(
          values);
      List<String> terminalsForThisLine = getTerminalsFromOneLineStr(values);

      ///Normal list logic
      //Val if exits element
      CompilerVariableModel? match = vars.firstWhere(
              (element) => element.varName == varName,
          orElse: () =>
              CompilerVariableModel(varName: "", terminals: [], productions: [])
      );
      if (match.varName.isEmpty) { //Not exists element in list
        vars.add(CompilerVariableModel(
            varName: varName,
            terminals: terminalsForThisLine,
            productions: productionsForThisLine
        ));
      } else { // exists element, update values
        int existVarIndex = vars.indexWhere((element) =>
        element.varName == varName,);
        CompilerVariableModel newValue = vars.elementAt(existVarIndex);
        newValue.productions =
        [... newValue.productions, ... productionsForThisLine];
        newValue.terminals = [... newValue.terminals, ... terminalsForThisLine];
        vars[existVarIndex] = newValue;
      }


      ///Recursion list logic
      int varNameLength = varName.length;

      String firstElement = productionsForThisLine.elementAt(0);
      String firstValueElementValidation = firstElement.substring(
          0, varNameLength);
      if (firstValueElementValidation == varName) { //Its left recursive
        //Creating alpha value
        String alphaValue = firstElement.substring(
            varNameLength, firstElement.length);

        //Creating A' (A1 for this course)
        String nameA1Var = "${varName}1";
        CompilerVariableModel productionA1 = CompilerVariableModel(
            varName: nameA1Var,
            terminals: terminalsForThisLine,
            productions: [
              "$alphaValue$nameA1Var",
              "'${GlobalConstants.epsilonSymbol}'"
            ]
        );

        List<String> productionsWithBA1Struct = createBA1ValuesInProductions(
            productionsForThisLine, nameA1Var);
        CompilerVariableModel newAVar = CompilerVariableModel(
            varName: varName,
            terminals: terminalsForThisLine,
            productions: productionsWithBA1Struct
        );

        varsWithoutRecursion.add(newAVar);
        varsWithoutRecursion.add(productionA1);
      } else {
        varsWithoutRecursion.add(CompilerVariableModel(
            varName: varName,
            terminals: terminalsForThisLine,
            productions: productionsForThisLine
        ));
      }
    }


    productions = getListProductionsFromCompilerVariableList(vars);
    terminals = getTerminalsFromCompilerVariableList(vars);

    notify(SetVariables(rows: vars));
    notify(SetProductions(productions));
    notify(SetTerminals(terminals));


    productionsWithoutRecursion =
        getListProductionsFromCompilerVariableList(varsWithoutRecursion);
    terminalsWithoutRecursion =
        getTerminalsFromCompilerVariableList(varsWithoutRecursion);


    notify(SetVariablesWithoutRecursion( rowsWithoutRecursion: varsWithoutRecursion));
    notify(SetProductionsWithoutRecursive(productionsWithoutRecursion));
  }


  List<String> firstFunction({
    required String varToEvaluated,
    required List<ProductionModel> productions,
    required List<String> terminals,
    required List<CompilerVariableModel> vars
  }) {

    List<String> firstFunctionElements = [];

    for(ProductionModel currentProduction in productions){
      if (currentProduction.varName == varToEvaluated ){

        String elementValueFinedToFirstFunction= "";
        String? terminalFound=_evaluateIfFirstElementFromProductionIsTerminal(currentProduction, terminals);
        CompilerVariableModel? varFound= _evaluateIfFirstElementFromProductionIsVar(currentProduction, vars);

        if(terminalFound != null){ //First rule, if its terminal add
          firstFunctionElements.add(terminalFound);
          elementValueFinedToFirstFunction = terminalFound;
        }else if (varFound != null){ //Second rule, if its var, calculate first function for this var
          List<String> firstToThisVar =  firstFunction(
              varToEvaluated: varFound.varName,
              productions: productions,
              terminals: terminals,
              vars: vars
          );
          elementValueFinedToFirstFunction = varFound.varName;
          firstFunctionElements = [...firstFunctionElements, ...firstToThisVar ];
        }

        //3 rule, if contains epsilon, calculate first function to next element
        String? foundEpsilon = firstFunctionElements.where((e){
          return e == GlobalConstants.epsilonSymbol  || e == "'${GlobalConstants.epsilonSymbol}'";
        }).firstOrNull;
        if(foundEpsilon != null ){
          //Get all elements for this production (Vars and terminals)
          List<String> elementsToThisProduction = getSeparatedElementsFromProduction(
              valueProductionToEvaluated: currentProduction.value,
              terminals: terminals,
              vars: vars
          );
          //Find index in list to elements from this production
          int indexOfElementToThisEvaluated = elementsToThisProduction.indexWhere((e){
            return e == elementValueFinedToFirstFunction;
          });

          String valueToEvaluatedInFirstFunctionNext ;
          //Validate if its last index
          if( (indexOfElementToThisEvaluated+1) == elementsToThisProduction.length){
            valueToEvaluatedInFirstFunctionNext = GlobalConstants.epsilonSymbol;
          }else{
            valueToEvaluatedInFirstFunctionNext = elementsToThisProduction.elementAt((indexOfElementToThisEvaluated+1));
          }
          List<String> firstToThisVar =  firstFunction(
              varToEvaluated: valueToEvaluatedInFirstFunctionNext,
              productions: productions,
              terminals: terminals,
              vars: vars
          );
          firstFunctionElements = [...firstFunctionElements, ...firstToThisVar];
        }
      }
    }

    return firstFunctionElements;
  }


  String? _evaluateIfFirstElementFromProductionIsTerminal( ProductionModel production,  List<String> terminals){
    String valueProductionToEvaluate = production.value;
    //Valuate if its epsilon
    if(valueProductionToEvaluate == GlobalConstants.epsilonSymbol){
      return valueProductionToEvaluate;
    }

    for (String terminal in terminals) {
      String currentTerminalWithApostrophe = "'$terminal'";
      int lengthCurrentTerminal = currentTerminalWithApostrophe.length;
      if (
        valueProductionToEvaluate.length >= lengthCurrentTerminal &&
        valueProductionToEvaluate.substring(0, lengthCurrentTerminal) ==
              currentTerminalWithApostrophe
      ) { //Its terminal
        return terminal;
      }
    }
    return null;
  }

  CompilerVariableModel? _evaluateIfFirstElementFromProductionIsVar( ProductionModel production,  List<CompilerVariableModel> vars){
    for (CompilerVariableModel currentVariable in vars) {

      String nameCurrentVariable = currentVariable.varName;
      int lengthCurrentVariable = nameCurrentVariable.length;
      String valueProductionToEvaluate = production.value;

      if (
        valueProductionToEvaluate.length >= lengthCurrentVariable &&
        valueProductionToEvaluate.substring(0, lengthCurrentVariable) == nameCurrentVariable
      ) { //Its var
        return currentVariable;
      }
    }
    return null;
  }

  List<String> getSeparatedElementsFromProduction ({
    required String valueProductionToEvaluated,
    required List<String> terminals,
    required List<CompilerVariableModel> vars,
  })  {
    List<String> elements =[];
    //first, evaluated terminals
    for(String terminal in terminals){
      String terminalWithApostrophe = "'$terminal'";
      if(valueProductionToEvaluated.contains(terminal)){
        elements.add(terminalWithApostrophe);
      }
    }
    //Evaluated vars
    for(CompilerVariableModel currentVar in vars){
      String varName = currentVar.varName;
      if(valueProductionToEvaluated.contains(varName)){
        elements.add(varName);
      }
    }
    elements = shortElementsToProductionInOrder(valueProductionToEvaluated, elements);
    return elements;
  }

  List<String> shortElementsToProductionInOrder(String productionValue, List<String> elements){
    List<String> shortedElements =[];
    while(shortedElements.length != elements.length){
      for(String element in elements){
        int longCurrentElement = element.length;
        if(productionValue.substring(0,longCurrentElement ) == element){
          shortedElements.add(element);
        }
      }
    }
    return shortedElements;
  }

}