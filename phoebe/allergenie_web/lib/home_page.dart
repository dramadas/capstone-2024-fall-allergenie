import 'package:datasci_barcode_scanning/search_recipe.dart';
import 'package:flutter/material.dart';
import 'upload_image_page.dart';
import 'package:google_fonts/google_fonts.dart';



class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  void_showDisclaimerDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext) {
        return AlertDialog(
          title: Text('Disclaimer'),
          content: Text('This app is a tool to assist with identifying potential allergens, but it cannot guarantee accuracy and should not replace professional medical advice or thorough label checking'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Agree'))
          ]);
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AllerGenie Homepage',
        style: GoogleFonts.montserrat(
          color: Color.fromARGB(237, 209, 172, 24),
          fontSize: 24,
        ),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(238, 39, 60, 2),
      ),
      backgroundColor: Color.fromARGB(255, 251, 247, 228),
      body: GestureDetector(
        onTap: () => void_showDisclaimerDialog(context), // show dialog on tap
      child: Stack(
        children:[
          // main content of the home page
        SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Title Text
            SizedBox(height: 20),
            Text(
              "Welcome to AllerGenie!",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)
              ) ,
            ),
            Center(
            child: Image.asset(
                  'assets/images/GreenLogo.png',
                  height: 300,),
                  ),
              SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Column:
                Expanded(
                  child: Column(
                    children: [
                    SizedBox(height: 50),
                    Image.asset(
                  'assets/images/AllergyDetection.png',
                  height: 300,),
                    SizedBox(height: 20),
                    Text("Check for Allergens in Your Favorite Foods!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(238, 39, 60, 2),)),
                    Text("Click below to snap or upload an image of a food barcode to find out!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
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
                foregroundColor: Color.fromARGB(238, 39, 60, 2),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: GoogleFonts.montserrat(fontSize: 18),
              ),
            ),
            
                  ],)
                  

            ),

                Expanded(
                  child: Column(
                    children: [
                    SizedBox(height: 50),
                    Image.asset(
                      'assets/images/Recipe.png',
                      height: 300,),
                    SizedBox(height: 20),
                    Text("Hungry for an Allergy Friendly Meal?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(238, 39, 60, 2),
                    )),
                    Text("Search below to find the next best recipe that fits your dietary restrictions!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),
                    )),
                    SizedBox(height: 10),
                    ElevatedButton(
                    onPressed: () {
                // Action for the first button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchRecipe()),
                );
              },
              child: Text('Recipe Generation'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(238, 39, 60, 2),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: GoogleFonts.montserrat(fontSize: 18),
              ),
            ),
            SizedBox(height:30),
                  ],)
            ),
              ]
            ),
            Text("ABOUT US",
              style: GoogleFonts.montserrat(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(245, 216, 176, 14))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text("Imagine a world where managing food allergies is as simple as taking a photo of your meal. That is the world we are creating with AllerGenie. Managing food allergies is a daily struggle for millions of people, with over 33 million Americans at risk of severe reaction.AllerGenie is an AI-powered mobile app that revolutionizes this process. With just a smartphone camera, users can instantly detect allergens in their food and receive personalized, safe meal suggestions. Our app combines cutting-edge AI for allergen detection with smart meal planning, providing a comprehensive solution that not only improves safety but also saves time and reduces stress for allergy sufferers.",
                      style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),),
                      textAlign: TextAlign.left,))
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text("Our Mission",
                      style: GoogleFonts.montserrat(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(245, 216, 176, 14),),
                      textAlign: TextAlign.left,)

                      )
            ),
             Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text("Turning food fear into food freedom one meal at a time!",
                      style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),),
                      textAlign: TextAlign.left,))
            ),
            Text("Meet Your Allergy-Free Wish Granters",
              style: GoogleFonts.montserrat(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(245, 216, 176, 14))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text("Our team consists of 7 graduate students in the University of California -- Berkeley's Masters in Data Science Program. AllerGenie is close to our hearts as 3 out of 7 memebers in our team navigate food allergy obstacles on the daily. This website was created to help others navigate their own food allergies through allergy detection and recipe generation.",
                      style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),),
                      textAlign: TextAlign.left,))
            ),

            Padding(padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Image.asset('images/Svein.JPG', width: 200, height: 200),
 
              Image.asset('images/Sean.png', width: 200, height: 200), 

              Image.asset('images/agnese.png', width: 200, height: 200), 

              Image.asset('images/Subha.jpg', width: 200, height: 200), 
 
              ]
            ),
           Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              SizedBox(
                width: 200,
                height: 50,
                child: Text("Svein Gonzalez",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)),
                textAlign:TextAlign.center,)
                ),

                SizedBox(
                width: 200,
                height: 50,
                child: Text("Sean McFetridge",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)),
                textAlign:TextAlign.center,)
                ),

                SizedBox(
                width: 200,
                height: 50,
                child: Text("Agnese Minazzo",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)),
                textAlign:TextAlign.center,)
                ),
 
                SizedBox(
                width: 200,
                height: 50,
                child: Text("Subha Pothuraju",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)),
                textAlign:TextAlign.center,)
                ),
                ]
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Image.asset('images/dhyuti.jpg', width: 200, height: 200),

              Image.asset('images/rita.png', width: 200, height: 200), 

              Image.asset('images/phoebe.jpg', width: 200, height: 200), 
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                width: 200,
                height: 50,
                child: Text("Dhyuti Ramadas",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)),
                textAlign:TextAlign.center,)
                ),

                SizedBox(
                width: 200,
                height: 50,
                child: Text("Rita Tu",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)),
                textAlign:TextAlign.center,)
                ),

               SizedBox(
                width: 200,
                height: 50,
                child: Text("Phoebe Yueh",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(238, 39, 60, 2)),
                textAlign:TextAlign.center,)
                ),]
            ),
            ]
            
            )),
          
            SizedBox(height: 10),    
            Text("How are our AI Cooks Up Safe Eats",
              style: GoogleFonts.montserrat(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(245, 216, 176, 14))),
                Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text("Our recipe generator uses the Llama 8B model, which was trained on 75,000 recipes found online to create safe and delicious allergy-friendly meals tailored to you! Simply input in your allergies and type of dish, then watch as AI delivers three delicious recipe ideas!",
                      style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),),
                      textAlign: TextAlign.left,))
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text("Our barcode scanning allergy detector was built using the Open Food Facts, a large collaborative databases that contains detailed information of ingredients and allergens of food products all around the world. Simply select the allergens, scan the barcode of the food item, then our allergy detector will indicate whether the food is safe to consume!",
                      style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),),
                      textAlign: TextAlign.left,))
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text("Cheers to delicious meals and worry-free dining -- bon appétit!",
                      style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color.fromARGB(237, 13, 1, 3),),
                      textAlign: TextAlign.left,))
            ),
          ],
          
        ),
        
      ),
    ),
        ],
      )
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
                  MaterialPageRoute(builder: (context) => SearchRecipe()),
                );
  },),
        ],
      )
      )
  ),
    );
  }
}
