

import 'package:compiladorestareauno/screen/Home/ui/HomeScreen.dart';
import 'package:compiladorestareauno/theme/Themes.dart';
import 'package:flutter/material.dart';
import 'core/GlobalConstants.dart';

void main(){
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      routes: {
        GlobalConstants.homeScreenPath: (_) =>const  Home(),
      },
      initialRoute: GlobalConstants.homeScreenPath,
    );
  }
}
