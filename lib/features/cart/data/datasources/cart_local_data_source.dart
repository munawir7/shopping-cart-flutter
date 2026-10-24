
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/cart_item_model.dart';
import '../../../products/domain/models/product_model.dart';

class CartLocalDataSource {
  static const String _cartStorageKey = 'shopping_cart_items';

  Future<List<CartItemModel>> loadCart() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCart = preferences.getString(_cartStorageKey);

    if (savedCart == null) {
      return [];
    }

    final List<dynamic> decodedItems = jsonDecode(savedCart);

    return decodedItems.map((item) {
      final productData =
          Map<String, dynamic>.from(item['product'] as Map);

      final product = ProductModel(
        id: productData['id'] as int,
        name: productData['name'] as String,
        description: productData['description'] as String,
        price: (productData['price'] as num).toDouble(),
        category: productData['category'] as String,
        image: productData['image'] as String,
      );

      return CartItemModel(
        product: product,
        quantity: item['quantity'] as int,
      );
    }).toList();
  }

  Future<void> saveCart(List<CartItemModel> items) async {
    final preferences = await SharedPreferences.getInstance();

    final savedItems = items.map((item) {
      return {
        'product': {
          'id': item.product.id,
          'name': item.product.name,
          'description': item.product.description,
          'price': item.product.price,
          'category': item.product.category,
          'image': item.product.image,
        },
        'quantity': item.quantity,
      };
    }).toList();

    await preferences.setString(
      _cartStorageKey,
      jsonEncode(savedItems),
    );
  }

  Future<void> clearCart() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_cartStorageKey);
  }
}
