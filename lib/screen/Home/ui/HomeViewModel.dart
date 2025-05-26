
import 'dart:ffi';
import 'dart:ui';

import 'package:compiladorestareauno/Model/CompilerVariableModel.dart';
import 'package:compiladorestareauno/Model/FunctionsVarModel.dart';
import 'package:compiladorestareauno/Model/ProductionModel.dart';
import 'package:compiladorestareauno/core/GlobalConstants.dart';
import 'package:compiladorestareauno/mvvm/viewModel.dart';
import 'package:compiladorestareauno/screen/Home/domain/HomeRepository.dart';
import 'package:compiladorestareauno/screen/Home/ui/HomeEvent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class HomeViewModel extends EventViewModel {
  HomeRepository repository;

  HomeViewModel(this.repository);

  void changeLoadingScreen(bool newState) {
    notify(ChangeLoadingScreen(newState));
  }


  Set<String> getTerminalsFromOneLineStr(String valueProduction,) {
    //Find the sub vars
    final subRegex = RegExp(r"('([^']+)')|(e)");
    Iterable<RegExpMatch> individualVars = subRegex.allMatches(valueProduction);
    List<String> varsThisProduction = [];
    for (var subMatch in individualVars) {
      if(subMatch[2] != null && subMatch[2]!.isNotEmpty ){
        varsThisProduction.add(subMatch[2]!);
      }
      if(subMatch[3] != null && subMatch[3]!.isNotEmpty ){
        varsThisProduction.add(subMatch[3]!);
      }
    }
    return varsThisProduction.toSet() ;
  }

  Set<String> getVarsFromOneLineStr(String valueProduction, Set<CompilerVariableModel> vars) {
    Set<String> varsMatch = {};
    String valueProduction0 = valueProduction;

    List<CompilerVariableModel> varsList = vars.toList();
    varsList.sort((a, b) => b.varName.length.compareTo(a.varName.length),);

    for (CompilerVariableModel varCurrent in varsList) {
      int lengthVarName = varCurrent.varName.length;
      if(valueProduction0.contains(varCurrent.varName)){
        valueProduction0 = valueProduction0.replaceAll(varCurrent.varName, "");
        varsMatch.add(varCurrent.varName);
      }
    }
    return varsMatch  ;
  }

  Set<ProductionModel> getProductionsFromOneLineStr( {
    required String valueProductions,
    required String varName,
    required Set<CompilerVariableModel> currentVars
  }) {
    List<String> productionsParts = valueProductions.split("|");
    Set<ProductionModel> productions={};
    for(String production in productionsParts){
      productions.add(ProductionModel(varName: varName, value: production, elements: {}));
    }
    return productions;
  }

  // Set<ProductionModel> getListProductionsFromCompilerVariableList(Set<CompilerVariableModel> vars) {
  //   Set<ProductionModel> productions = {};
  //   for (CompilerVariableModel currentVar in vars) {
  //     for (String production in currentVar.productions) {
  //       productions.add(
  //           ProductionModel(varName: currentVar.varName, value: production));
  //     }
  //   }
  //   return productions;
  // }

  Set<String> getTerminalsFromCompilerVariableList(List<CompilerVariableModel> vars) {
    Set<String> terminals = {} ;
    for (CompilerVariableModel currentVar in vars) {
      for (ProductionModel production in currentVar.productions) {
        terminals.addAll(getTerminalsFromOneLineStr(production.value));
      }
    }
    return terminals;
  }


  void compile(String code) {
    //final variablesRegexCompile = RegExp(r"\s*([A-Za-z0-9_]+)\s*=\s*((('([A-Za-z0-9 _]*)')|([A-Za-z0-9_]+))+(\s*\|\s*(('[A-Za-z0-9 _]*')+|([A-Za-z0-9_]+))+)*)");
    final variablesRegexCompile = RegExp( r"\s*(.*)\s*=\s*((('.*')|(.+))+(\s*\|\s*(('.*')+|(.+))+)*)");
    Iterable<RegExpMatch> variablesMatches = variablesRegexCompile.allMatches(code);

    //Init
    String varName;
    String values;

    Set<CompilerVariableModel> vars = {} ;

    ///Generate normal vars
    for (var matches in variablesMatches) {
      varName = matches.group(1) ?? "N/A";
      values = matches.group(2) ?? "N/A";

      Set<String> terminalsForThisMatch = getTerminalsFromOneLineStr(values);
      Set<ProductionModel> productionsForThisMatch = getProductionsFromOneLineStr(
          valueProductions: values,
          varName: varName,
          currentVars: vars
      );

      CompilerVariableModel? match = vars.firstWhere(
        (element) => element.varName == varName,
        orElse: () =>CompilerVariableModel(varName: "", terminals: {}, productions: {} )
      );
      if (match.varName.isEmpty) { //Not exists element in list
        vars.add(CompilerVariableModel(
            varName: varName,
            terminals: terminalsForThisMatch,
            productions: productionsForThisMatch
        ));
      } else { // exists element, update values
        match.terminals.addAll(terminalsForThisMatch);
        match.productions.addAll(productionsForThisMatch);
        vars.add(match);
      }
    }

    //Calculated individual Elements and recursion values
    for(CompilerVariableModel cv in vars){
      for(ProductionModel p in cv.productions){
        Set<String> elements = getSeparatedElementsFromProduction(
            valueProductionToEvaluated: p.value,
            vars: vars
        );
        p.elements = elements;
        //Validate if is recursion var
        if(elements.isNotEmpty &&  elements.first== cv.varName){//Its left recursion
          cv.isLeftRecursive = true;
        }
      }
      vars.add(cv);
    }

  
    ///Generate without recursion vars
    Set<CompilerVariableModel> varsWithoutRecursion = {}; 
    Set<CompilerVariableModel> varsToMod =  Set.from(vars);
    for(CompilerVariableModel currentVar in varsToMod){
      if(currentVar.isLeftRecursive){
        CompilerVariableModel newVar = CompilerVariableModel(
            varName: currentVar.varName,
            terminals: {} ,
            productions: {}
        );
        CompilerVariableModel varA1 = CompilerVariableModel(
            varName: "${currentVar.varName}1",
            terminals: {},
            productions: {}
        );

        //Calculated beta productions
        for(ProductionModel prod in currentVar.productions){
          if(prod.elements.isNotEmpty && prod.elements.first != currentVar.varName){
            newVar.productions.add(ProductionModel(
                varName: currentVar.varName,
                value: "${prod.value}${currentVar.varName}1",
                elements: {... Set.from(prod.elements), ...{"${currentVar.varName}1"}}
            ));
          } else {//Alpha production

            //A1 prod
            ProductionModel newProdA1 = ProductionModel(
                varName: "${currentVar.varName}1",
                value: prod.value,
                elements: Set.from(prod.elements)
            );
            String newValue = "${newProdA1.value
                .substring(newProdA1.varName.length, newProdA1.value.length)}${newProdA1.varName}";

            String firstElement =  newProdA1.elements.first;
            newProdA1.elements.remove(firstElement);
            newProdA1.elements.add("${currentVar.varName}1");
            newProdA1.value= newValue;

            //Epsilon prod
            ProductionModel epsilonA1Prod = ProductionModel(
                varName: "${currentVar.varName}1",
                value:GlobalConstants.epsilonSymbol,
                elements: {GlobalConstants.epsilonSymbol}
            );

            varA1.productions.add(newProdA1);
            varA1.productions.add(epsilonA1Prod);

          }
        }
        varsWithoutRecursion.add(newVar);
        varsWithoutRecursion.add(varA1);
      }else{
        varsWithoutRecursion.add(currentVar);
      }
    }


    ///Set normal components
    Set<ProductionModel> productions = {};
    Set<String> terminals =  {};
    //Calculated productions and terminals
    for(CompilerVariableModel cv in vars){
      for(ProductionModel p in cv.productions){
        productions.add(p);
      }
      for(String t in cv.terminals){
        terminals.add(t);
      }
    }
    notify(SetVariables(rows: vars));
    notify(SetProductions(productions));
    notify(SetTerminals(terminals));


    ///Set without recursion components
    //Calculated productions and terminals
    Set<ProductionModel> productionsWithoutRecursion  = {};
    for(CompilerVariableModel cv in varsWithoutRecursion){
      for(ProductionModel p in cv.productions){
        productionsWithoutRecursion.add(p);
      }
    }
    notify(SetVariablesWithoutRecursion( rowsWithoutRecursion: varsWithoutRecursion));
    notify(SetProductionsWithoutRecursive(productionsWithoutRecursion));


    ///First and second funciton
    Set<FunctionsVarModel> functions = {};
    for(CompilerVariableModel v in varsWithoutRecursion){
      Set<String> firstFunc =firstFunction(varToEvaluated: v, allVars: varsWithoutRecursion);

      Set<String> nextFunctionList =nextFunction(
          varsWithoutRecursion: varsWithoutRecursion,
          allProductions: productionsWithoutRecursion,
          varToEvaluated: v.varName
      );

      functions.add(
          FunctionsVarModel(
              varName: v.varName,
              firstFunction: firstFunc,
              nextFunction:nextFunctionList
          )
      );

    }
    notify(SetFirstAndNextFunctions(functions));
    Set<String> nextFunc =nextFunction(
      varsWithoutRecursion: varsWithoutRecursion,
      varToEvaluated: "T",
      allProductions: productionsWithoutRecursion
    );
    print(nextFunc);
  }


  Set<String> firstFunction({
    required CompilerVariableModel varToEvaluated,
    required Set<CompilerVariableModel> allVars,
    bool removedEpsilon = false
  }) {

    Set<String> firstFunctionElements = {};
    for(ProductionModel currentProduction in varToEvaluated.productions){

      //validate if is var
      CompilerVariableModel varFound =
        allVars.firstWhere((cv) => cv.varName == currentProduction.elements.first,
        orElse: ()=>CompilerVariableModel(
            varName: "",
            terminals: {},
            productions: {})
        );
      
      String elementValueFinedToFirstPosition = "";
      if(varFound.varName.isEmpty){  //First rule, if its terminal add
        String firstPosition = currentProduction.elements.first;
        firstFunctionElements.add(firstPosition);
        elementValueFinedToFirstPosition = firstPosition;
      }else { //Second rule, if its var, calculate first function for this var
        Set<String> firstToThisVar =  firstFunction(
            varToEvaluated: varFound,
            allVars: allVars
        );
        firstFunctionElements.addAll(firstToThisVar);
      }

      //3 rule, if contains epsilon, calculate first function to next element
      if(
        firstFunctionElements.contains(GlobalConstants.epsilonSymbol) ||
        firstFunctionElements.contains("'${GlobalConstants.epsilonSymbol}'")
      ){
        //Get all elements for this production (Vars and terminals)
        List<String> elementsToThisProduction = currentProduction.elements.toList();

        //Find index in list to elements from this production
        int indexOfElementToThisEvaluated = elementsToThisProduction.indexWhere((e){
          return e == elementValueFinedToFirstPosition;
        });

        String valueToEvaluatedInFirstFunctionNext ;
        //Validate if its last index
        if( (indexOfElementToThisEvaluated+1) == elementsToThisProduction.length){
          valueToEvaluatedInFirstFunctionNext = GlobalConstants.epsilonSymbol;
          firstFunctionElements.add(GlobalConstants.epsilonSymbol);
        }else{
          valueToEvaluatedInFirstFunctionNext = elementsToThisProduction.elementAt((indexOfElementToThisEvaluated+1));
          CompilerVariableModel? secondElement = allVars.firstWhere(
                  (a)=> a.varName==valueToEvaluatedInFirstFunctionNext
          );
          Set<String> firstToThisVar =  firstFunction(
              varToEvaluated: secondElement,
              allVars: allVars
          );
          firstFunctionElements.addAll(firstToThisVar);
        }


      }
    }
    if(removedEpsilon){
      firstFunctionElements.removeWhere((e)=> e==GlobalConstants.epsilonSymbol || e=="'${GlobalConstants.epsilonSymbol}'");
    }
    return firstFunctionElements;
  }


  Set<String> getSeparatedElementsFromProduction ({
    required String valueProductionToEvaluated,
    required Set<CompilerVariableModel> vars,
  })  {
    Set<String> elements = {};

    //Get vars
    Set<String> varsForThisVal = getVarsFromOneLineStr(valueProductionToEvaluated, vars);
    Set<String> terminalsForThisVal = getTerminalsFromOneLineStr(valueProductionToEvaluated);

    elements.addAll(varsForThisVal);
    elements.addAll(terminalsForThisVal);
    valueProductionToEvaluated = valueProductionToEvaluated.replaceAll("'", "");
    elements = shortElementsToProductionInOrder(valueProductionToEvaluated.trim(), elements);
    return elements;
  }

  Set<String> shortElementsToProductionInOrder(String productionValue, Set<String> elements){
    Set<String> shortedElements = {};
    elements.removeWhere((e) => e == GlobalConstants.epsilonSymbol);
    while(shortedElements.length != elements.length){
      for(String element in elements){
        int longCurrentElement = element.length;
        if( longCurrentElement<= productionValue.length && productionValue.substring(0,longCurrentElement ) == element){
          productionValue = productionValue.replaceFirst(element, "");
          shortedElements.add(element);
          break;
        }
      }
    }
    return shortedElements;
  }


  Set<String> nextFunction({
    required Set<CompilerVariableModel> varsWithoutRecursion, 
    required Set<ProductionModel> allProductions,
    required String varToEvaluated,
  }){

    Set<String> nextFunctionList = {};

    for(ProductionModel currentProduction in allProductions){
      List<String> elementsToThisProduction = currentProduction.elements.toList();

      //If not contains var, next production was evaluated
      if(!elementsToThisProduction.contains(varToEvaluated)) continue;

      //Condition to apply second rule S(B) = P(Beta)
      int varToEvaluatedIndex = elementsToThisProduction.indexWhere((e) => e==varToEvaluated);
      if(varToEvaluatedIndex < (elementsToThisProduction.length-1) && varToEvaluatedIndex != -1){ //Apply Rule
        //Validate if is var
        String nextElementValue = elementsToThisProduction.elementAt(varToEvaluatedIndex+1);
        CompilerVariableModel matchVar = varsWithoutRecursion.firstWhere((a)=>
          a.varName==nextElementValue,
          orElse:()=> CompilerVariableModel(varName: "", terminals: {}, productions: {})
        );
        //if is not var, its terminal so add and continue
        if(matchVar.varName.isEmpty){
          nextFunctionList.add(nextElementValue);
          continue;
        }
        Set<String> firstFunctionToB = firstFunction(
            varToEvaluated: matchVar,
            allVars: varsWithoutRecursion,
            removedEpsilon: true
        );
        nextFunctionList.addAll(firstFunctionToB);
      }
      //Condition to apply third rule, S(B) = S(A)
      Set<String> firstFunctionToB  = {};
      if(varToEvaluatedIndex == (elementsToThisProduction.length -1)){
        firstFunctionToB.add(GlobalConstants.epsilonSymbol);
      }else {
        //Find var right position for this element
        CompilerVariableModel matchVar = varsWithoutRecursion.firstWhere((a)=>
            a.varName==elementsToThisProduction.elementAt(varToEvaluatedIndex+1),
            orElse:()=> CompilerVariableModel(varName: "", terminals: {}, productions: {})
        );

        if(matchVar.varName.isNotEmpty){ //Next Element is a var
          firstFunctionToB = firstFunction(
              varToEvaluated: matchVar ,
              allVars: varsWithoutRecursion,
          );
        }else{//Its terminal
          firstFunctionToB = {elementsToThisProduction.elementAt(varToEvaluatedIndex+1)};
        }
      }

      if(firstFunctionToB.contains(GlobalConstants.epsilonSymbol) || firstFunctionToB.contains("'${GlobalConstants.epsilonSymbol}'") ){
        if(varToEvaluated != currentProduction.varName){
          Set<String> nextFunctionA= nextFunction(
              varsWithoutRecursion: varsWithoutRecursion,
              varToEvaluated:  currentProduction.varName,
              allProductions: allProductions,
          );
          nextFunctionList.addAll(nextFunctionA);
        }
      }

    }
    // First rule, add delimiter symbol
    nextFunctionList.add(GlobalConstants.delimiterSymbol);

    return nextFunctionList;
  }


}