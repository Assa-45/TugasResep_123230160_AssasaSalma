class ProductModel {
  final String id;
  final String name;
  final String instruction;
  final String category;
  final String country;
  final String image;

  final List<String> ingredients;
  final List<String> measures;

  ProductModel({
    required this.id,
    required this.name,
    required this.instruction,
    required this.category,
    required this.country,
    required this.image,
    required this.ingredients,
    required this.measures,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

     for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];

      // cek null dan kosong
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(
          measure != null && measure.trim().isNotEmpty
              ? measure
              : ''
        );
      }
    }

    return ProductModel(
      id: json['idMeal'],
      name: json['strMeal'],
      instruction: json['strInstructions'],
      category: json['strCategory'],
      country: json['strCountry'],
      image: json['strMealThumb'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}