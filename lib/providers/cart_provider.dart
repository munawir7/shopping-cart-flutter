
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  static const String _cartStorageKey = 'shopping_cart_items';

  final List<CartItemModel> _items = [];

  bool _isLoading = true;

  // Returns an unmodifiable view of cart items.
  List<CartItemModel> get items => List.unmodifiable(_items);

  // Indicates whether saved cart data is being restored.
  bool get isLoading => _isLoading;

  // Total quantity of all products.
  int get totalItems {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  // Total number of different products.
  int get uniqueProductCount => _items.length;

  // Total price before discount.
  double get subtotal {
    return _items.fold(0.0, (total, item) => total + item.subtotal);
  }

  // Apply a 10% discount when subtotal exceeds ₹2,000.
  double get discount {
    return subtotal > 2000 ? subtotal * 0.10 : 0.0;
  }

  // Final price after discount.
  double get totalPrice => subtotal - discount;

  // Whether the cart contains any products.
  bool get isEmpty => _items.isEmpty;

  CartProvider() {
    loadCart();
  }

  // Restore cart data when the provider is created.
  Future<void> loadCart() async {
    _isLoading = true;

    try {
      final preferences = await SharedPreferences.getInstance();
      final savedCart = preferences.getString(_cartStorageKey);

      if (savedCart != null) {
        final List<dynamic> decodedItems = jsonDecode(savedCart);

        _items
          ..clear()
          ..addAll(
            decodedItems.map((item) {
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
            }),
          );
      }
    } catch (error) {
      debugPrint('Error loading saved cart: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save current cart data to SharedPreferences.
  Future<void> _saveCart() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final savedItems = _items.map((item) {
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
    } catch (error) {
      debugPrint('Error saving cart: $error');
    }
  }

  // Add a product or increase its existing quantity.
  void addToCart(ProductModel product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(
        CartItemModel(
          product: product,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
    _saveCart();
  }

  // Increase the quantity of a cart item.
  void increaseQuantity(int productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) return;

    _items[index].quantity++;

    notifyListeners();
    _saveCart();
  }

  // Decrease quantity without allowing it to fall below one.
  void decreaseQuantity(int productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;

      notifyListeners();
      _saveCart();
    }
  }

  // Remove a product from the cart.
  void removeFromCart(int productId) {
    final previousLength = _items.length;

    _items.removeWhere(
      (item) => item.product.id == productId,
    );

    if (_items.length != previousLength) {
      notifyListeners();
      _saveCart();
    }
  }

  // Clear the cart after successful checkout.
  void clearCart() {
    if (_items.isEmpty) return;

    _items.clear();

    notifyListeners();
    _saveCart();
  }

  // Check whether a product is already in the cart.
  bool containsProduct(int productId) {
    return _items.any(
      (item) => item.product.id == productId,
    );
  }

  // Get the quantity of a specific product.
  int quantityOf(int productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) return 0;

    return _items[index].quantity;
  }
}

