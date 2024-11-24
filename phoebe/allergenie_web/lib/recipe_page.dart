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
import 'home_page.dart';
import 'upload_image_page.dart';
import 'search_recipe.dart';

class RecipePage extends StatelessWidget {
  // Sample recipe data
  final String title = "Vegan Lentil Tacos";
  final String description = "A delicious vegan taco recipe that avoides soy.";
  final List<String> ingredients = [
    "2 cups lentils, cooked (from 1 cup dry lentils)",
    "white onion, finely diced",
    "1-2 garlic cloves",
    "1/4 cup of vegetable broth",
    "corn or flour tortillas, for serving",
    "Taco Toppings: shredded lettuce, sliced jalapenos, homemade guacamole",
  ];
  final List<String> steps = [
    "In a large frying pan, over medium heat, sweat the onions in 1 tbsp. oil. Then add garlic and spice mixture.",
    "Warm the tortillas in the microwave.",
    "Add lentils and stir to combine. Then add vegetable broth and using a potatoe masher or fork, gently mash the lentils.",
    "Place a heaping spoonful or two into the taco shell and add your fillings.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AllerGenie Recipe',
        style: TextStyle(
          color: Color.fromARGB(237, 209, 172, 24),
          fontSize: 24,
        ),), 
        centerTitle: true,
        backgroundColor: const Color.fromARGB(238, 39, 60, 2),
      ),
      backgroundColor: Color.fromARGB(255, 251, 247, 228),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image
            
            SizedBox(height: 16.0),
            Image.asset(
              'assets/images/vegan_taco.jpg',
              height: 300,
            ),

            // Recipe title and description
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.0),

            // Ingredients
            Text(
              "Ingredients",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            ...ingredients.map((ingredient) => Text("• $ingredient")).toList(),
            SizedBox(height: 16.0),

            // Steps
            Text(
              "Instructions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            ...steps.asMap().entries.map((entry) {
              int stepIndex = entry.key + 1;
              String step = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("$stepIndex. $step"),
              );
            }).toList(),
          ],
        ),
      ),
      ),
bottomNavigationBar: BottomAppBar(
    color: const Color.fromARGB(238, 39, 60, 2),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         IconButton(
          icon:Icon(Icons.photo_camera) ,
          color: Color.fromARGB(237, 209, 172, 24),
          onPressed: () {
                // Action for the first button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadImagePage()),
                );
  },),
        IconButton(
          icon:Icon(Icons.home) ,
          color: Color.fromARGB(237, 209, 172, 24),
          onPressed: () {
                // Action for the first button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
  },),
        IconButton(
          icon:Icon(Icons.search) ,
          color: Color.fromARGB(237, 209, 172, 24),
          onPressed: () {
                // Action for the first button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchRecipePage()),
                );
  },),
      
        ],
      )
      )
  ),
    );
  }
}
