import 'dart:typed_data';
import 'package:datasci_barcode_scanning/search_recipe.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; //remove later
import 'api_service.dart';
import 'result_page.dart'; 
import 'home_page.dart';

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  Uint8List? imageData;
  final ApiService apiService = ApiService('http://100.29.58.53:5000'); // Set your base API URL
  // final ApiService apiService = ApiService('http://127.0.0.1:5000'); // Set your base API URL & USE THIS FOR LOCAL TESTING

  // List of allergens
  List<String> allergens = [
    'milk',
    'gluten',
    'nuts',
    'soybeans',
    'peanuts',
    'celery',
    'crustaceans',
    'mustard',
    'sesame-seeds'
  ];
  List<String> selectedAllergens = []; // Selected allergens

  // Step 1: Allergen Selection
  Widget allergenSelection() {
    return Wrap(
      spacing: 10, 
      runSpacing: 10,
      children: allergens.map((allergen) {
        return FilterChip(
          label: Text(allergen, style: TextStyle(fontSize: 16)),
          selected: selectedAllergens.contains(allergen),
          onSelected: (bool value) {
            toggleAllergen(allergen);
          },
          selectedColor: Colors.white, 
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: selectedAllergens.contains(allergen) ? Colors.black : Colors.black, // Change label text color to black
          ),
        );
      }).toList(),
    );
  }

  // Step 2: Image Upload
  // void pickImage() {
  void pickImage(ImageSource source) async {
    if (kIsWeb) {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files!.isEmpty) return;

        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]);

        reader.onLoadEnd.listen((e) {
          setState(() {
            imageData = reader.result as Uint8List?;
          });
        });
      });
    } else {
      final picker = ImagePicker();
      try {
        final pickedFile = await picker.pickImage(source: source);

        if (pickedFile != null) {
          // Read the bytes of the image
          final bytes = await pickedFile.readAsBytes();

          // Update the image data state
          setState(() {
            imageData = bytes;
          });

          // Optionally, upload the image immediately after picking
          uploadImage(imageData!);
        } else {
          print('No image selected.');
        }
      } catch (e) {
        print('Error picking image: $e');
      }
    }
  }
  //     final picker = ImagePicker();
  //     // picker.pickImage(source: ImageSource.gallery).then((pickedFile) {
  //     picker.pickImage(source: source).then((pickedFile) { // remove if it doesnt work
  //       setState(() {
  //         if (pickedFile != null) {
  //           pickedFile.readAsBytes().then((bytes) {
  //             imageData = bytes;
  //           });
  //         }
  //       });
  //     });
  //   }
  // }

void uploadImage(Uint8List imageData) async {
  try {
    // Create multipart request
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${apiService.baseUrl}/upload')
    );

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'file', 
      imageData, 
      filename: 'image.png', 
      contentType: MediaType('image', 'png'),
    ));

    // Add the selected allergens as a comma-separated string
    request.fields['allergens'] = selectedAllergens.join(',');

    // Send the request
    var streamedResponse = await request.send();

    // Convert StreamedResponse to a regular Response
    var response = await http.Response.fromStream(streamedResponse);

    // Check response status and parse the response body
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            safetyStatus: responseData['safety_status'],
            output: responseData['output'],
          ),
        ),
      );
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}


  // Toggle selected allergens
  void toggleAllergen(String allergen) {
    setState(() {
      if (selectedAllergens.contains(allergen)) {
        selectedAllergens.remove(allergen);
      } else {
        selectedAllergens.add(allergen);
      }
    });
  }

  void _showImageSourceDialog() { // remove all of this if this doesnt work
  // Show dialog to choose between camera or gallery
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera); // Capture image from camera
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery); // Pick image from gallery
              },
            ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(238, 39, 60, 2),
        title: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Text(
                    'Welcome to AllerGenie!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'This is your place for real-time allergen detection.',
                    style: TextStyle(color: Colors.white70, fontSize: 14), 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 246, 243, 226),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Image.asset(
                  'assets/images/GreenLogo.png',
                  height: 100, 
                ),
              ),
            ),
            Text(
              'Step 1: Select Allergens',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            // Instruction text for uploading barcode image
            Text(
              'Please upload a barcode image from your device.',
              style: TextStyle(fontSize: 16, color: Colors.black54), 
              textAlign: TextAlign.center, 
            ),
            SizedBox(height: 20),
            allergenSelection(),
            SizedBox(height: 40),

            // Step 2: Upload Barcode Image
            Text(
              'Step 2: Upload Barcode Image',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            // Instruction text for uploading barcode image
            Text(
              'Please upload a barcode image from your device.',
              style: TextStyle(fontSize: 16, color: Colors.black54), // Adjust style as needed
              textAlign: TextAlign.center, // Center the text
            ),
            SizedBox(height: 10),
            imageData != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.memory(
                      imageData!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
            SizedBox(height: 20),
            ElevatedButton.icon( // remove this if it doesnt work
              onPressed: _showImageSourceDialog, // Open dialog to choose between camera and gallery
              icon: Icon(Icons.upload, size: 24),
              label: Text('Select Image', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            
            // ElevatedButton.icon(
            //   onPressed: pickImage,
            //   icon: Icon(Icons.upload, size: 24),
            //   label: Text('Select Barcode Image', style: TextStyle(fontSize: 18)),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //   ),
            // ),
            SizedBox(height: 40),

            // Submit button to check for allergens
            ElevatedButton.icon(
              onPressed: imageData != null
                  ? () => uploadImage(imageData!)
                  : null, // Check allergens only if image is uploaded
              icon: Icon(Icons.check_circle, size: 24),
              label: Text('Check for Allergens', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 30), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Go back to Home Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchRecipePage())
                );
              },
              child: Text('Try the Recipe Generator!'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Go back to Home Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage())
                );
              },
              child: Text('Go Back to Home Page'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}