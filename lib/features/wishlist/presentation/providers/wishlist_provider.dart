
import 'package:flutter/foundation.dart';
import 'package:shopping_cart_app/features/wishlist/data/datasources.dart/wishlist_local_datasourc.dart';
import 'package:shopping_cart_app/features/wishlist/domain/repositories/wishlist_repositories.dart';
import 'package:shopping_cart_app/features/wishlist/domain/repositories/wishlist_repository_impl.dart';

import '../../../products/domain/models/product_model.dart';


class WishlistProvider extends ChangeNotifier {
  final WishlistRepository _repository;
  final List<ProductModel> _wishlist = [];

  bool _isLoading = true;
  bool _disposed = false;
  Future<void> _saveQueue = Future<void>.value();

  WishlistProvider({WishlistRepository? repository})
      : _repository = repository ??
            WishlistRepositoryImpl(
              localDataSource: WishlistLocalDataSource(),
            ) {
    loadWishlist();
  }

  List<ProductModel> get wishlist => List.unmodifiable(_wishlist);

  int get wishlistCount => _wishlist.length;

  bool get isLoading => _isLoading;

  bool isInWishlist(int productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  Future<void> loadWishlist() async {
    _isLoading = true;

    if (!_disposed) {
      notifyListeners();
    }

    try {
      final savedProducts = await _repository.loadWishlist();

      if (_disposed) return;

      _wishlist
        ..clear()
        ..addAll(savedProducts);
    } catch (error) {
      debugPrint('Error loading wishlist: $error');
    } finally {
      _isLoading = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  void _saveWishlist() {
    final snapshot = List<ProductModel>.from(_wishlist);

    _saveQueue = _saveQueue
        .then((_) => _repository.saveWishlist(snapshot))
        .catchError((Object error) {
      debugPrint('Error saving wishlist: $error');
    });
  }

  void toggleWishlist(ProductModel product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      _wishlist.add(product);
      notifyListeners();
      _saveWishlist();
    }
  }

  void removeFromWishlist(int productId) {
    if (!isInWishlist(productId)) return;

    _wishlist.removeWhere((product) => product.id == productId);

    notifyListeners();
    _saveWishlist();
  }

  void clearWishlist() {
    if (_wishlist.isEmpty) return;

    _wishlist.clear();

    notifyListeners();
    _saveWishlist();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

