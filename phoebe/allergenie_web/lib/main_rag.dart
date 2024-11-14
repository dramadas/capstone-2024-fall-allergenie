import 'package:flutter/material.dart';
import 'rag_screen/home_screen.dart';

void main() {
  runApp(RecipeGeneratorApp());
}

class RecipeGeneratorApp extends StatelessWidget {
  const RecipeGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
