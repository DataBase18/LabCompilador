
import 'package:compiladorestareauno/mvvm/observer.dart';


class ShowSimpleAlert extends ViewEvent {
  String message;
  Function()? onAccept;

  ShowSimpleAlert(this.message, {this.onAccept}) :super("ShowSimpleAlert");
}

class ChangeLoadingScreen extends ViewEvent {
  bool newState;

  ChangeLoadingScreen(this.newState) :super("ChangeLoadingScreen");
}

