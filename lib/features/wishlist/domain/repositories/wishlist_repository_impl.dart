
import 'package:shopping_cart_app/features/wishlist/data/datasources.dart/wishlist_local_datasourc.dart';
import 'package:shopping_cart_app/features/wishlist/domain/repositories/wishlist_repositories.dart';

import '../../../products/domain/models/product_model.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<ProductModel>> loadWishlist() {
    return localDataSource.loadWishlist();
  }

  @override
  Future<void> saveWishlist(List<ProductModel> products) {
    return localDataSource.saveWishlist(products);
  }

  @override
  Future<void> clearWishlist() {
    return localDataSource.clearWishlist();
  }
}

