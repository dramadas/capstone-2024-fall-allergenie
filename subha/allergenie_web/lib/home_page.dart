import 'package:flutter/material.dart';
import 'upload_image_page.dart';
import 'recipe_page.dart';



class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AllerGenie Homepage',
        style: TextStyle(
          color: Color.fromARGB(237, 209, 172, 24),
          fontSize: 24,
        ),), 
        centerTitle: true,
        backgroundColor: const Color.fromARGB(238, 39, 60, 2),
      ),
      backgroundColor: Color.fromARGB(255, 246, 243, 226),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Title Text
            SizedBox(height: 20),
            Text(
              "AllerGenie",
              style: TextStyle(
                fontSize: 75,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)
              ) , 
            ),
            SizedBox(height: 50),
            Image.asset(
                  'assets/images/GreenLogo.png',
                  height: 300,),
            SizedBox(height: 50),
            Text("ABOUT US",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(245, 216, 176, 14))),
            Text("Imagine a world where managing food allergies is as simple as taking a photo of your meal. That is the world we are creating with AllerGenie.",
            style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),)),
            Text("Managing food allergies is a daily struggle for millions of people, with over 33 million Americans at risk of severe reaction.",
            style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),)

            ),
            Text("AllerGenie is an AI-powered mobile app that revolutionizes this process. With just a smartphone camera, users can instantly detect allergens in their food and receive personalized, safe meal suggestions.",
            style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),)),
            Text("Our app combines cutting-edge AI for allergen detection with smart meal planning, providing a comprehensive solution that not only improves safety but also saves time and reduces stress for allergy sufferers.",
            style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Column: 
                Expanded( 
                  child: Column(
                    children: [
                    SizedBox(height: 20),
                    Text("Check for Allergens in Your Favorite Foods!",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(238, 39, 60, 2),)),
                    Text("Click below to snap or upload an image of a food barcode to find out!",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(237, 13, 1, 3),)),
                    SizedBox(height: 10),
                    ElevatedButton(
                    onPressed: () {
                // Action for the first button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadImagePage()),
                );
              },
              child: Text('Allergy Detection'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
                  ],)  
               
            ),
                
                Expanded( 
                  child: Column(
                    children: [
                    SizedBox(height: 20),
                    Text("Hungry for an Allergy Friendly Meal?",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(238, 39, 60, 2),
                    )),
                    Text("Search below to find the next best recipe that fits your dietary restrictions!",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(237, 13, 1, 3),
                    )),
                    SizedBox(height: 10),
                    Container(
                      width: 700,
                      child:
                    TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Let's Cook! Search for a Recipe...",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchController.clear(); // Clear the search bar
                  },
                ),
              ),
            ),
                    ),
                    ElevatedButton(
                    child: Text('Search'),
                    onPressed: () {
                // Action for the first button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipePage()),
                );
              },
            ),
            SizedBox(height:30),
                  ],)    
            ),
              ]
            )
          ],
            
        ),
      ),
    ),
    );
  }
}
