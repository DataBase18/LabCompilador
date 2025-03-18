
import 'package:compiladorestareauno/mvvm/viewModel.dart';
import 'package:compiladorestareauno/screen/Home/domain/HomeRepository.dart';
import 'package:compiladorestareauno/screen/Home/ui/HomeEvent.dart';


class HomeViewModel extends EventViewModel {
  HomeRepository repository;

  HomeViewModel(this.repository);

  void changeLoadingScreen(bool newState) {
    notify(ChangeLoadingScreen(newState));
  }

  void compile (String code){
    String regexVariableName = r"\s*(\w+)\s*=(.*)";
    String regexValueWithApostrophe = r"\s*'(.*)'\s*";
    String regexValueWithoutApostrophe = r"\s*([A-Za-z0-9_-]+)\s*";
    

    final variablesRegexCompile = RegExp(regexVariableName);
    Iterable<RegExpMatch> variablesMatches = variablesRegexCompile.allMatches(code);


    String regexOrPart = "(\s*($regexValueWithApostrophe)|($regexValueWithoutApostrophe))(\\|(($regexValueWithApostrophe)|($regexValueWithoutApostrophe)))+";
    String regexOnlyVarPart = "($regexValueWithApostrophe)|($regexValueWithoutApostrophe)";
    String valueVar ;
    String varName ;

    // 4 PRIMER VAIRABLE CCON APOSTROFE
    // 6 PRIMER VAIRABLE SIN APOSTROFE
    // 12 REGEX EN OR SIN APOSTROFE
    // 15 variable sola con apostrofe
    // 17 variable sola sin apostrofe

    for(var matchVariable in variablesMatches){
      valueVar = matchVariable.group(2)??"";
      varName = matchVariable.group(1)??"";

      //Find                                            13
      final varsValueMatches =  RegExp("($regexOrPart)|($regexOnlyVarPart)");
      final matchesValues = varsValueMatches.allMatches(valueVar);
      for(var match in matchesValues){

        if(match.group(1) != null){
          print("Resto de condicionales:   ${match.group(1) }");
        }
        if(match.group(15) != null){
          print("Variable sola con apostrofe: ${match.group(15) }");
        }
        if(match.group(17) != null){
          print("Variable sola SIN apostrofe: ${match.group(17) }");
        }

      }

    }


  }

}