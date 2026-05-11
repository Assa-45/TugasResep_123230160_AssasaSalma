import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';


class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key, required this.mealId,});
  final String mealId;
  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  static const Color primaryColor = Color(0xFF2A9D8F);
  static const Color accentColor = Color(0xFF264653);

  ApiService apiService = ApiService();
  late Future<ProductModel> productFuture;
  late Box<ProductModel> favBox;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    favBox = Hive.box<ProductModel>('favBox');

    productFuture = apiService.getSingleMeal(widget.mealId);
    checkFavorite();
  }

  void checkFavorite() {
    final isExist =
        favBox.containsKey(
          widget.mealId,
        );

    setState(() {
      _isFavorite = isExist;
    });
  }

  void toggleFavorite(ProductModel product) async {
    if (_isFavorite) {
      await favBox.delete(product.id);
    } else {
      await favBox.put(product.id, product);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Gagal load detail"),
            );
          }
          final product = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: primaryColor,
                leading: GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back, color: accentColor),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: primaryColor.withOpacity(0.2),
                      child: const Icon(Icons.restaurant, size: 80),
                    ),
                  ),
                ),
              ),
          
              // Konten detail
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
          
                      const SizedBox(height: 12),
          
                      // Category chips
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(
                              product.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            backgroundColor: primaryColor.withOpacity(0.1),
                            side: BorderSide(color:primaryColor.withOpacity(0.3),),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,),

                            Chip(
                            label: Text(
                              product.country,
                              style: TextStyle(
                                fontSize: 12,
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            backgroundColor: accentColor.withOpacity(0.1),
                            side: BorderSide(color:accentColor.withOpacity(0.3),),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,),
                        ],
                      ),
          
                      const SizedBox(height: 20),
          
                      // Tombol favorit
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            toggleFavorite(product);
                          },
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                          ),
                          label: Text(
                            _isFavorite ? 'Delete from Favorite': 'Add to Favorite',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isFavorite ? const Color(0xFFE76F51) : primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                          ),
                        ),
                      ),
          
                      const SizedBox(height: 28),
          
                      // Bahan-bahan
                      Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...product.ingredients.asMap().entries.map(
                        (entry) {

                          final index = entry.key;
                          final ing = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),

                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  width: 8,
                                  height: 8,

                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    '${product.measures[index]} $ing',

                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          
                      const SizedBox(height: 28),
          
                      // Cara Memasak
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      Text(
                        product.instruction
                            .replaceAll('\r\n', '\n'),

                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.8,
                        ),

                        textAlign: TextAlign.justify,
                      ),
                                          ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}