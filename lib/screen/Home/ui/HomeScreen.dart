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
}