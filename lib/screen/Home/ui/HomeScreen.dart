import 'package:compiladorestareauno/screen/Home/ui/HomeWidget.dart';
import 'package:compiladorestareauno/widget/AlertBasic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:compiladorestareauno/mvvm/observer.dart';
import '../domain/HomeRepository.dart';
import 'HomeState.dart';
import 'HomeEvent.dart';
import 'HomeViewModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> implements EventObserver {

  final HomeState state = HomeState();
  final HomeViewModel viewModel = HomeViewModel(HomeRepository());

  @override
  void initState() {
    super.initState();
    viewModel.subscribe(this);
  }

  @override
  void dispose() {
    viewModel.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeBody(state: state, viewModel: viewModel);
  }

  @override
  void notify(ViewEvent event) {
    switch (event.runtimeType) {
      case ShowSimpleAlert:
        _handleShowSimpleAlert(event as ShowSimpleAlert);
        break;
      case ChangeLoadingScreen:
        _handleChangeLoadingScreen(event as ChangeLoadingScreen);
        break;
      case SetVariables:
        _handleSetVariables(event as SetVariables);
        break;
      case SetProductions:
        _handleSetProductions(event as SetProductions);
        break;
      case SetTerminals:
        _handleSetTerminals(event as SetTerminals);
        break;
      case SetProductionsWithoutRecursive:
        _handleSetProductionsWithoutRecursive(event as SetProductionsWithoutRecursive);
        break;
      case SetVariablesWithoutRecursion:
        _handleSetVariablesWithoutRecursion(event as SetVariablesWithoutRecursion);
        break;
      case SetFirstAndNextFunctions:
        _handleSetFirstAndNextFunctions(event as SetFirstAndNextFunctions);
        break;
    }
  }

  void _handleShowSimpleAlert(ShowSimpleAlert event) {
    showCupertinoDialog(
        context: context,
        builder: (_) =>
            AlertBasic(content: event.message, onAccept: event.onAccept)
    );
  }

  void _handleChangeLoadingScreen(ChangeLoadingScreen event) {
    setState(() {
      state.loadingScreen = event.newState;
    });
  }

  void _handleSetVariables(SetVariables event) {
    setState(() {
      state.vars=event.rows;
    });
  }

  void _handleSetProductions(SetProductions event) {
    setState(() {
      state.productions  = event.productions;
    });
  }

  void _handleSetTerminals(SetTerminals event) {
    setState(() {
      state.terminals = event.terminals;
    });
  }

  void _handleSetProductionsWithoutRecursive(SetProductionsWithoutRecursive event) {
    setState(() {
      state.productionsWithoutRecursion = event.productionsWithoutRecursive;
    });
  }

  void _handleSetVariablesWithoutRecursion(SetVariablesWithoutRecursion event) {
    setState(() {
      state.varsWithoutRecursion = event.rowsWithoutRecursion;
    });
  }

  void _handleSetFirstAndNextFunctions(SetFirstAndNextFunctions event) {
    setState(() {
      state.functions  = event.functions;
    });
  }
}