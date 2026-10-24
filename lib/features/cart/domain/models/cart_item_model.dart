import '../../../products/domain/models/product_model.dart';

class CartItemModel {
final ProductModel product;
int quantity;

CartItemModel({
required this.product,
this.quantity = 1,
}) : assert(quantity >= 1, 'Quantity must be at least 1');

double get subtotal => product.price * quantity;
}
