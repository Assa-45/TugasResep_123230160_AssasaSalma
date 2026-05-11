import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/category_model.dart';

class ApiService {

  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<ProductModel>> fetchMeals() async {

    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s=')
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      List meals = data['meals'];

      return meals
          .map((meal) => ProductModel.fromJson(meal))
          .toList();

    } else {
      throw Exception('Failed fetch meals');
    }
  }

  Future<ProductModel> getSingleMeal(String mealId) async {

    final response = await http.get(
      Uri.parse('$baseUrl/lookup.php?i=$mealId')
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return ProductModel.fromJson(
        data['meals'][0]
      );

    } else {
      throw Exception('Failed fetch detail meal');
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {

    final response = await http.get(
      Uri.parse('$baseUrl/list.php?c=list')
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      List meals = data['meals'];

      return meals
          .map((item) => CategoryModel.fromJson(item))
          .toList();

    } else {
      throw Exception('Failed fetch categories');
    }
  }
}