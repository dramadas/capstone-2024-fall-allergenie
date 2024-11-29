class RecipeResponse {
  final String? recipe;
  final Map<String, String>? images; // Can be null if images are not generated.

  RecipeResponse({this.recipe, this.images});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    // If 'images' is null or not available, it will return an empty map.
    return RecipeResponse(
      recipe: json['recipe'],
      images: json['images'] != null 
          ? (json['images'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, value.toString()), 
            )
          : null,
    );
  }
}