
import 'package:flutter/foundation.dart';

import '../models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _wishlist = [];

  List<ProductModel> get wishlist => List.unmodifiable(_wishlist);

  int get wishlistCount => _wishlist.length;

  bool isInWishlist(int productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  void toggleWishlist(ProductModel product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(int productId) {
    if (!isInWishlist(productId)) {
      return;
    }

    _wishlist.removeWhere(
      (product) => product.id == productId,
    );

    notifyListeners();
  }

  void clearWishlist() {
    if (_wishlist.isEmpty) {
      return;
    }

    _wishlist.clear();
    notifyListeners();
  }
}
