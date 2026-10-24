
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../products/domain/models/product_model.dart';

class WishlistLocalDataSource {
  static const String _wishlistStorageKey = 'shopping_wishlist_items';

  Future<List<ProductModel>> loadWishlist() async {
    final preferences = await SharedPreferences.getInstance();

    final savedWishlist = preferences.getString(_wishlistStorageKey);

    if (savedWishlist == null) {
      return [];
    }

    final List<dynamic> decodedWishlist = jsonDecode(savedWishlist);

    return decodedWishlist.map((item) {
      final product = Map<String, dynamic>.from(item as Map);

      return ProductModel(
        id: product['id'] as int,
        name: product['name'] as String,
        description: product['description'] as String,
        price: (product['price'] as num).toDouble(),
        category: product['category'] as String,
        image: product['image'] as String,
      );
    }).toList();
  }

  Future<void> saveWishlist(List<ProductModel> products) async {
    final preferences = await SharedPreferences.getInstance();

    final savedWishlist = products.map((product) {
      return {
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'image': product.image,
      };
    }).toList();

    await preferences.setString(
      _wishlistStorageKey,
      jsonEncode(savedWishlist),
    );
  }

  Future<void> clearWishlist() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_wishlistStorageKey);
  }
}

