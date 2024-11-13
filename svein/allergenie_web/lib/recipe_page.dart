import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; //remove later
import 'api_service.dart';
import 'recipe_page.dart'; 

class RecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('AllerGenie Homepage',
        style: TextStyle(
          color: Color.fromARGB(237, 209, 172, 24),
          fontSize: 24,
        ),), 
        centerTitle: true,
        backgroundColor: const Color.fromARGB(238, 39, 60, 2),),
      backgroundColor: Color.fromARGB(255, 246, 243, 226),
      );
  }
}