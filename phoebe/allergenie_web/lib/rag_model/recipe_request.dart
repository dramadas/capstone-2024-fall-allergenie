class RecipeRequest {
  final String allergy;
  final String dish_type;

  RecipeRequest({
    required this.allergy,
    required this.dish_type,
  });

  Map<String, dynamic> toJson() {
    return {
      'allergy': allergy,
      'dish_type': dish_type,
    };
  }

  @override
  String toString() {
    return 'RecipeRequest{allergy: $allergy, dish_type: $dish_type}';
  }
}