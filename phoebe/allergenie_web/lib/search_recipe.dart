import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'upload_image_page.dart'; // Add import for the UploadImagePage
import 'package:url_launcher/url_launcher.dart';
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
  bool _generateImages = false; 
  bool _isLoading = false;
  bool _showDialog = false;
  Map<String, String>? _images;


  List<String> selectedAllergies = [];
  final List<String> allergyOptions = [
    'milk', 'egg', 'fish', 'shellfish', 'treenut', 'peanut', 'wheat', 'soy','no allergies'
  ];

  void _restartPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SearchRecipe()), 
    );
  }

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
      generate_images: _generateImages,
    );

    final response = await _apiService.generateRecipe(request);

    setState(() {
    if (response != null) {
      _recipe = response.recipe ?? "No recipe found.";
      _images = _generateImages ? response.images : {}; 
    } else {
      _recipe = "No recipe found.";
      _images = {};  
    }
    _isLoading = false;
    _showDialog = true;
    });
  }


  Widget _buildDisclaimerBanner() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width, 
      ),
      child: Container(
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildRecipeText() {
    // Split the recipe into parts and identify bold keywords
    List<TextSpan> spans = [];
    final boldWords = ["Title", "Ingredients", "Instructions"];
    final recipeWords = ["Recipe 1", "Recipe 2", "Recipe 3"];
    
    _recipe.split('\n').forEach((line) {
      bool isBold = boldWords.any((word) => line.startsWith(word));
      bool isRecipe = recipeWords.any((word) => line.contains(word));
      
      spans.add(TextSpan(
        text: line + '\n',
        style: GoogleFonts.montserrat(
          fontSize: isRecipe ? 23 : 16, 
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: const Color.fromARGB(238, 39, 60, 2),
        ),
      ));
    });

    return RichText(
      text: TextSpan(
        children: spans,
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
                trailing: Icon(Icons.arrow_drop_down, color: Color.fromARGB(238, 39, 60, 2)),
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
                  borderSide: BorderSide(color: Color.fromARGB(238, 39, 60, 2), width: 2.0),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 246, 243, 226),
              ),
            ),
            const SizedBox(height: 16),
            // Step 3: Image generation toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step 3: Generate AI images for recipe?',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(245, 216, 176, 14),
                  ),
                ),
                Switch(
                  value: _generateImages,
                  onChanged: (bool value) {
                    setState(() {
                      _generateImages = value;
                    });
                  },
                  activeColor: Color.fromARGB(238, 39, 60, 2),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Note: Generating AI images may take longer to load. Please be patient as the images are generated by AI and may not fully represent the actual recipe.',
              style: TextStyle(
                color: Color.fromARGB(238, 39, 60, 2),
                fontSize: 14,
                fontStyle: FontStyle.italic, 
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
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(238, 39, 60, 2)),
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
                                  // Display all images if they are available
                                  if (_images != null && _images!.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          spacing: 8.0, // Space between columns
                                          runSpacing: 8.0, // Space between rows
                                          alignment: WrapAlignment.spaceEvenly,
                                          children: _images!.entries.map((entry) {
                                            return GestureDetector(
                                              onTap: () async {
                                                if (await canLaunchUrl(Uri.parse(entry.value))) {
                                                  await launchUrl(Uri.parse(entry.value));
                                                } else {
                                                  throw 'Could not launch ${entry.value}';
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width / 4 - 16,
                                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                    // Display the recipe title (key)
                                                      child: Text(
                                                        entry.key, // Recipe title (key)
                                                        style: GoogleFonts.montserrat(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color.fromARGB(238, 39, 60, 2),
                                                        ),
                                                        maxLines: null,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    // Display the image from the URL
                                                    AspectRatio(
                                                      aspectRatio: 1, // Ensure square aspect ratio
                                                      child: Image.network(
                                                        entry.value, // Display the image URL from the map value
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ] else ...[
                                      // If no images are available, show an empty container without text
                                      Container(
                                        height: 10,
                                      ),
                                    ],
                                    // display generated recipes
                                    _buildRecipeText(),
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

