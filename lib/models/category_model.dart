class CategoryModel {
  final String category;

  CategoryModel({
    required this.category,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['strCategory'],
    );
  }
}