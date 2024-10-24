// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;


// class ApiService {
//   final String baseUrl;

//   ApiService(this.baseUrl);

//   Future<String> uploadImage(Uint8List imageData) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/upload'), 
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({'image': base64Encode(imageData)}),
//     );

//     if (response.statusCode == 200) {
//       return response.body;
//     } else {
//       throw Exception('Failed to upload image');
//     }
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> uploadImage(Uint8List imageData, List<String> allergens) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/upload'), 
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'image': base64Encode(imageData), 
          'allergens': allergens,  // Sending allergens in the request body
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to upload image: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error during image upload');
    }
  }
}