
import 'package:flutter/foundation.dart';
import 'package:shopping_cart_app/features/cart/data/repositories/cart_repositories_impl.dart';
import 'package:shopping_cart_app/features/cart/domain/repositories/cart_repositories.dart';

import '../../../products/domain/models/product_model.dart';
import '../../data/datasources/cart_local_data_source.dart';
import '../../domain/models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;
  final List<CartItemModel> _items = [];

  bool _isLoading = true;
  bool _disposed = false;
  Future<void> _saveQueue = Future<void>.value();

  CartProvider({CartRepository? repository})
      : _repository = repository ??
            CartRepositoryImpl(
              localDataSource: CartLocalDataSource(),
            ) {
    loadCart();
  }

  List<CartItemModel> get items => List.unmodifiable(_items);

  bool get isLoading => _isLoading;

  int get totalItems =>
      _items.fold(0, (total, item) => total + item.quantity);

  int get uniqueProductCount => _items.length;

  double get subtotal =>
      _items.fold(0.0, (total, item) => total + item.subtotal);

  double get discount => subtotal > 2000 ? subtotal * 0.10 : 0.0;

  double get totalPrice => subtotal - discount;

  bool get isEmpty => _items.isEmpty;

  Future<void> loadCart() async {
    _isLoading = true;

    if (!_disposed) {
      notifyListeners();
    }

    try {
      final savedItems = await _repository.loadCart();

      if (_disposed) return;

      _items
        ..clear()
        ..addAll(savedItems);
    } catch (error) {
      debugPrint('Error loading saved cart: $error');
    } finally {
      _isLoading = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  void _saveCart() {
    final snapshot = _items
        .map(
          (item) => CartItemModel(
            product: item.product,
            quantity: item.quantity,
          ),
        )
        .toList();

    _saveQueue = _saveQueue
        .then((_) => _repository.saveCart(snapshot))
        .catchError((Object error) {
      debugPrint('Error saving cart: $error');
    });
  }

  void addToCart(ProductModel product) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(
        CartItemModel(product: product, quantity: 1),
      );
    }

    notifyListeners();
    _saveCart();
  }

  void increaseQuantity(int productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) return;

    _items[index].quantity++;

    notifyListeners();
    _saveCart();
  }

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

  void clearCart() {
    if (_items.isEmpty) return;

    _items.clear();

    notifyListeners();
    _saveCart();
  }

  bool containsProduct(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int quantityOf(int productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) return 0;

    return _items[index].quantity;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

