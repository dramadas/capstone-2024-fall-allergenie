class RecipeRequest {
  final String allergy;
  final String dish_type;
  final bool generate_images;

  RecipeRequest({
    required this.allergy,
    required this.dish_type,
    required this.generate_images,
  });

  Map<String, dynamic> toJson() {
    return {
      'allergy': allergy,
      'dish_type': dish_type,
      'generate_images': generate_images,
    };
  }
}