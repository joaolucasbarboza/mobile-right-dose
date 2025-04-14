import 'package:flutter/material.dart';
import 'package:tcc/ui/components/navigationBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          onPrimary: Colors.white,
        ),
      ),
      home: NavigationComponent(),
    );
  }
}
