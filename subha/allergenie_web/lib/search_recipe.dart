import 'package:datasci_barcode_scanning/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'upload_image_page.dart';

class SearchRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class SearchRecipe extends StatefulWidget {
  @override
  _AllergyRecipePageState createState() => _AllergyRecipePageState();
}

class _AllergyRecipePageState extends State<SearchRecipe> {
  // List of allergy options
  final List<String> allergies = [
    "Milk",
    "Egg",
    "Fish",
    "Shellfish",
    "Treenut",
    "Peanut",
    "Wheat",
    "Soy"
  ];

  // Track selected allergies
  final Map<String, bool> selectedAllergies = {};

  // Track the user's entered food item
  String foodItem = '';

  // TextEditingController for the search box
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize all allergies as unselected
    for (var allergy in allergies) {
      selectedAllergies[allergy] = false;
    }
  }

  // Helper function to build the dynamic sentence
  String getAllergySentence() {
    // Get list of selected allergies
    List<String> chosenAllergies = selectedAllergies.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.toLowerCase())
        .toList();

    if (chosenAllergies.isEmpty || foodItem.isEmpty) {
      return "Please select allergies and enter a food item.";
    }

    // Join allergies with proper "and" grammar
    String allergiesText;
    if (chosenAllergies.length == 1) {
      allergiesText = chosenAllergies[0];
    } else {
      allergiesText = chosenAllergies.sublist(0, chosenAllergies.length - 1).join(", ") +
          " and " +
          chosenAllergies.last;
    }

    return "I am allergic to $allergiesText. Can you give me a $foodItem recipe free of $allergiesText?";
  }

  // Function to update the search box with dynamic text
  void _updateSearchBoxText() {
    _searchController.text = getAllergySentence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AllerGenie Recipe Search Page',
          style: GoogleFonts.montserrat(
            color: Color.fromARGB(237, 209, 172, 24),
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(238, 39, 60, 2),
      ),
      backgroundColor: Color.fromARGB(255, 246, 243, 226),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
            child: Image.asset(
                  'assets/images/Ingredients.png',
                  height: 300,),),
  
            Text(
              "Select any allergies you have:",
              style: GoogleFonts.montserrat(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(245, 216, 176, 14))
            ),
            SizedBox(height: 10),
            // Allergy checkboxes
            Expanded(
              child: ListView(
                children: allergies.map((allergy) {
                  return CheckboxListTile(
                    title: Text(allergy),
                    value: selectedAllergies[allergy],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedAllergies[allergy] = value ?? false;
                        _updateSearchBoxText();
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 50),
            // TextField for entering the food item
            Text(
              "Enter the dish you wish to prepare:",
              style: GoogleFonts.montserrat(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(245, 216, 176, 14))
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter the food item",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  foodItem = value;
                  _updateSearchBoxText();
                });
              },
            ),
            SizedBox(height: 50),
            // Search box with dynamic text and search button
            Text(
              "Double-check your recipe request and get ready to cook up some magic!",
              style: GoogleFonts.montserrat(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(245, 216, 176, 14))
            ),
            TextField(
              controller: _searchController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Search for recipe",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Searching for Recipe"),
                          content: Text(_searchController.text),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "DISCLAIMER",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(245, 219, 7, 7))
            ),
             Text(
              "For optimal safety and accuracy, we recommend consulting with your healthcare provider regarding the suitability of AllerGenie's recipe to avoid any potential health risks.",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Color.fromARGB(245, 219, 7, 7))
            ),
          ],
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
                icon: Icon(Icons.photo_camera),
                color: Color.fromARGB(237, 209, 172, 24),
                onPressed: () {
                  // Action for the first button
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadImagePage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.home),
                color: Color.fromARGB(237, 209, 172, 24),
                onPressed: () {
                  // Action for the home button
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: Color.fromARGB(237, 209, 172, 24),
                onPressed: () {
                  // Action for the search button
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchRecipe()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
