import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'upload_image_page.dart'; // Add import for the UploadImagePage
import '../rag_model/recipe_request.dart';
import '../api_service_recipe_generator.dart';

class SearchRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchRecipe(),
    );
  }
}

class SearchRecipe extends StatefulWidget {
  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  final TextEditingController _dishTypeController = TextEditingController();
  final ApiServiceRAG _apiService = ApiServiceRAG();
  String _recipe = "";
  bool _isLoading = false;
  bool _showDialog = false;

  List<String> selectedAllergies = [];
  final List<String> allergyOptions = [
    'milk', 'egg', 'fish', 'shellfish', 'treenut', 'peanut', 'wheat', 'soy',
  ];

  Future<void> _getRecipe() async {
    if (selectedAllergies.isEmpty || _dishTypeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out both fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final request = RecipeRequest(
      allergy: selectedAllergies.join(', '),
      dish_type: _dishTypeController.text,
    );

    final response = await _apiService.generateRecipe(request);

    setState(() {
      _recipe = response?.recipe ?? "No recipe found.";
      _isLoading = false;
      _showDialog = true;
    });
  }

  Widget _buildDisclaimerBanner() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.orange, width: 2.0),
      ),
      child: Text(
        "⚠️ Disclaimer: For optimal safety and accuracy, we recommend consulting with your healthcare provider regarding the suitability of AllerGenie's recipe to avoid any potential health risks.",
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 243, 226),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image at the top
              Center(
                child: Image.asset(
                  'assets/images/Recipe.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 16),
              // Question Banner
              Text(
                "AllerGenie Recipe Generator",
                style: GoogleFonts.montserrat(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(245, 216, 176, 14),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Allergy multi-select dropdown
              Text(
                'Step 1: Select any allergies you have',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(245, 216, 176, 14),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(238, 39, 60, 2)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    selectedAllergies.isEmpty
                        ? 'Select Allergies'
                        : selectedAllergies.join(', '),
                    style: TextStyle(color: Color.fromARGB(238, 39, 60, 2)),
                  ),
                  trailing:
                      Icon(Icons.arrow_drop_down, color: Color.fromARGB(238, 39, 60, 2)),
                  onTap: () async {
                    final List<String>? result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiSelectDialog(
                          options: allergyOptions,
                          selectedOptions: selectedAllergies,
                        );
                      },
                    );
                    if (result != null) {
                      setState(() {
                        selectedAllergies = result;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Step 2: Enter the meal/cuisine type you wish to prepare:',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(245, 216, 176, 14),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dishTypeController,
                decoration: InputDecoration(
                  hintText: 'Enter meal/cuisine type',
                  hintStyle: TextStyle(color: Color.fromARGB(238, 39, 60, 2)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color.fromARGB(238, 39, 60, 2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Color.fromARGB(238, 39, 60, 2), width: 2.0),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 246, 243, 226),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getRecipe,
                child: Text(
                  'Generate Recipe',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(238, 39, 60, 2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color.fromARGB(238, 39, 60, 2)),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Cooking up some magic...🧑‍🍳",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Color.fromARGB(238, 39, 60, 2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : (_recipe.isNotEmpty)
                      ? Column(
                          children: [
                            _buildDisclaimerBanner(),
                            SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 8.0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _recipe,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(238, 39, 60, 2),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _showDialog = false;
                                          _recipe = "";
                                        });
                                      },
                                      child: const Text('Close'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(238, 39, 60, 2),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
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
                icon: Icon(Icons.photo_camera),
                color: Color.fromARGB(237, 209, 172, 24),
                onPressed: () {
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
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

class MultiSelectDialog extends StatefulWidget {
  final List<String> options;
  final List<String> selectedOptions;

  MultiSelectDialog({
    required this.options,
    required this.selectedOptions,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Select Allergies',
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(238, 39, 60, 2),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: widget.options.map((option) {
            return CheckboxListTile(
              title: Text(
                option,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Color.fromARGB(238, 39, 60, 2),
                ),
              ),
              value: selected.contains(option),
              activeColor: Color.fromARGB(238, 39, 60, 2),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    selected.add(option);
                  } else {
                    selected.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, selected);
          },
          child: Text(
            'Done',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(238, 39, 60, 2), // Green color
            ),
          ),
        ),
      ],
    );
  }
}