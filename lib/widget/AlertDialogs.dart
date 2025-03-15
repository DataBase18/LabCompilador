import 'package:flutter/material.dart';
import 'InputBasic.dart';

Future<String?> showTextInputDialog(BuildContext context,{
  String title = "Ingrese un dato",
  String inputLabel = "Ej. Amor",
  String cancelTextButton="Cancelar",
  String acceptTextButton="Aceptar"
}) async {
  TextEditingController textController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: InputBasic(
          controller: textController,
          labelText: inputLabel,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(cancelTextButton),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: Text(acceptTextButton),
            onPressed: () {
              Navigator.of(context).pop(textController.text);
            },
          ),
        ],
      );
    },
  );
}