import 'package:hive/hive.dart';
part 'hive_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String instruction;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String country;

  @HiveField(5)
  final String image;

  @HiveField(6)
  final List<String> ingredients;

  @HiveField(7)
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

  factory ProductModel.fromJson(
      Map<String, dynamic> json) {

    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {

      String? ingredient =
          json['strIngredient$i'];

      String? measure =
          json['strMeasure$i'];

      if (ingredient != null &&
          ingredient.trim().isNotEmpty) {

        ingredients.add(ingredient);

        measures.add(
          measure != null &&
                  measure.trim().isNotEmpty
              ? measure
              : '',
        );
      }
    }

    return ProductModel(
      id: json['idMeal'],
      name: json['strMeal'],
      instruction:
          json['strInstructions'],
      category:
          json['strCategory'],
      country:
          json['strArea'],
      image:
          json['strMealThumb'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}