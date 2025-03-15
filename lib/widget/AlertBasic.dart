import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertBasic extends StatelessWidget {
  AlertBasic({super.key, this.title  , required this.content, this.buttonText, this.onAccept  });
  final String? title;
  final String content;
  final String? buttonText;
  final Function? onAccept;

  bool firstEntry =true;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog( 
      actions: [
        TextButton(
          child: Text(buttonText??"Aceptar"),
          onPressed: () {
            Navigator.pop(context);
            if(onAccept!= null){
              onAccept!();
            }
          },
        )
      ],
      title: Text(title??"Aviso"),
      content: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (v) {
          if (v.logicalKey == LogicalKeyboardKey.enter && !firstEntry ) {
            Navigator.pop(context);
          }
          firstEntry=false;
        },
        child: Text(content)
      ),
    );
  }
}