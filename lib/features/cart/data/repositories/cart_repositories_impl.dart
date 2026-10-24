
import 'package:shopping_cart_app/features/cart/domain/repositories/cart_repositories.dart';

import '../../domain/models/cart_item_model.dart';

import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<CartItemModel>> loadCart() {
    return localDataSource.loadCart();
  }

  @override
  Future<void> saveCart(List<CartItemModel> items) {
    return localDataSource.saveCart(items);
  }

  @override
  Future<void> clearCart() {
    return localDataSource.clearCart();
  }
}

