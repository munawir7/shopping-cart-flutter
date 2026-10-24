
import '../models/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> loadCart();

  Future<void> saveCart(List<CartItemModel> items);

  Future<void> clearCart();
}

