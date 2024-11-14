class RecipeResponse {
  final String question;
  final String recipe;

  RecipeResponse({required this.question, required this.recipe});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    return RecipeResponse(
      question: json['question'],
      recipe: json['recipe'],
    );
  }
}