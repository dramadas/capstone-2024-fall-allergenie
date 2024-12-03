import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:flutter/services.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Allergy Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
