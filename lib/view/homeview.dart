import 'package:flutter/material.dart';
import 'package:resep_app/view/favoriteview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resep_app/view/login.dart';
import 'productview.dart';
import '../services/api_service.dart';

import '../models/product_model.dart';
import '../models/category_model.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ApiService apiService = ApiService();
  int _bottomNavIndex = 0;

  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<CategoryModel> categories = [];
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';
  bool isLoading = true;

  static const Color primaryColor = Color(0xFF2A9D8F);
  static const Color accentColor = Color(0xFF264653);
  static const Color bgColor = Color(0xFFF5FAF9);

  void loadData() async {
    final meals = await apiService.fetchMeals();
    final fetchedCategories =await apiService.fetchCategories();

    setState(() {
      allProducts = meals;
      filteredProducts = meals;
      categories = [
        CategoryModel(category: 'All'),
        ...fetchedCategories,
      ];
      isLoading = false;
    });
  }

  void filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = allProducts.where((product) {
        final matchSearch =
            product.name
                .toLowerCase()
                .contains(query);
        final matchCategory =
            selectedCategory == 'All'
                ? true
                : product.category ==
                    selectedCategory;
        return matchSearch && matchCategory;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget buildHomePage() {
    return isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // SEARCH
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterProducts();
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),

          // CATEGORY
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {

                final isSelected =
                    selectedCategory ==
                    categories[index].category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory =
                          categories[index].category;
                    });

                    filterProducts();
                  },

                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor
                          : Colors.white,

                      borderRadius:
                          BorderRadius.circular(20),

                      border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),

                    alignment: Alignment.center,

                    child: Text(
                      categories[index].category,

                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // GRID
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),

              itemBuilder: (context, index) {

                final recipe =
                    filteredProducts[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),

                  clipBehavior: Clip.antiAlias,

                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailView(
                            mealId: recipe.id,
                          ),
                        ),
                      );
                    },

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Expanded(
                          child: Image.network(
                            recipe.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) {
                              return Container(
                                color:
                                    Colors.grey.shade200,
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.name,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                recipe.category,
                                style: TextStyle(
                                  color:
                                      Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          _bottomNavIndex == 0 ? "My Recipe" : "My Favorite",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('loginData', false);
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginView(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body:  _bottomNavIndex == 0
        ? buildHomePage()
        : const FavoriteView(),
          
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) {
          setState(() {
            _bottomNavIndex = i;
          });
        },

        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.white,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}