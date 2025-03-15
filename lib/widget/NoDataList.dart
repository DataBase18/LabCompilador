

import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class NoDataList extends StatelessWidget {
  const NoDataList({super.key, this.lottiePath, this.text});
  final String? lottiePath ;
  final String? text;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text ?? "Sin datos para mostrar",
          style: const TextStyle(
            fontSize: 18
          ),
        ),
        SizedBox(height: height*0.01,),
        Lottie.asset(
          lottiePath ?? "assets/dreamAnimation.json"
        )
      ],
    );
  }
}
