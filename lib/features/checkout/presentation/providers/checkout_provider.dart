import 'package:flutter/foundation.dart';

import '../../../cart/presentation/providers/cart_provider.dart';

class CheckoutProvider extends ChangeNotifier {
bool _isProcessingOrder = false;

bool get isProcessingOrder => _isProcessingOrder;

Future<bool> placeOrder(CartProvider cartProvider) async {
if (cartProvider.isEmpty || _isProcessingOrder) {
return false;
}

_isProcessingOrder = true;
notifyListeners();

try {
  // This is a demo checkout; no real payment is processed.
  cartProvider.clearCart();
  return true;
} finally {
  _isProcessingOrder = false;
  notifyListeners();
}


}
}
