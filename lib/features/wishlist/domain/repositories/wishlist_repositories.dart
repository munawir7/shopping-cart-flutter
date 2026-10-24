
import '../../../products/domain/models/product_model.dart';

abstract class WishlistRepository {
  Future<List<ProductModel>> loadWishlist();

  Future<void> saveWishlist(List<ProductModel> products);

  Future<void> clearWishlist();
}
