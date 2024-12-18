import 'package:flutter/material.dart';
import 'home_page.dart';

class SearchRecipePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Allergy Friendly Recipes',
        style: TextStyle(
          color: Color.fromARGB(237, 209, 172, 24),
          fontSize: 24,
          ),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(238, 39, 60, 2),
      ),
      body: Center(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //adding the logo
              Image.asset(
                'assets/images/GreenLogo.png',
                height: 300,
              ),
              SizedBox(height: 100),
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
            SizedBox(height: 20), // Add some spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('Search'),
                  onPressed: () {
                    String searchText = _searchController.text;
                    // You can implement the search functionality here
                    print('Searching for: $searchText');
                  },
                ),
                ElevatedButton(
                  child: Text('Go Back to Home Page'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> HomePage())
                    ); // Go back to the home page
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),);
  }
}