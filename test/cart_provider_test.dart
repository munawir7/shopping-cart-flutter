
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart_app/features/products/domain/models/product_model.dart';
import 'package:shopping_cart_app/features/products/presentation/providers/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CartProvider cartProvider;

  const testProduct = ProductModel(
    id: 1,
    name: 'Test Headphones',
    description: 'Wireless headphones for testing',
    price: 1500.0,
    category: 'Electronics',
    image: 'https://example.com/headphones.jpg',
  );

  const cheapProduct = ProductModel(
    id: 2,
    name: 'Test Notebook',
    description: 'Notebook for testing',
    price: 200.0,
    category: 'Accessories',
    image: 'https://example.com/notebook.jpg',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    cartProvider = CartProvider();

    // Wait for asynchronous cart restoration to finish.
    await cartProvider.loadCart();
  });

  tearDown(() {
    cartProvider.dispose();
  });

  test('Cart starts empty', () {
    expect(cartProvider.isEmpty, isTrue);
    expect(cartProvider.totalItems, 0);
    expect(cartProvider.subtotal, 0.0);
    expect(cartProvider.discount, 0.0);
    expect(cartProvider.totalPrice, 0.0);
  });

  test('Adding a product adds it to the cart', () {
    cartProvider.addToCart(testProduct);

    expect(cartProvider.isEmpty, isFalse);
    expect(cartProvider.totalItems, 1);
    expect(cartProvider.uniqueProductCount, 1);
    expect(cartProvider.containsProduct(testProduct.id), isTrue);
  });

  test('Adding the same product increases its quantity', () {
    cartProvider.addToCart(testProduct);
    cartProvider.addToCart(testProduct);

    expect(cartProvider.totalItems, 2);
    expect(cartProvider.uniqueProductCount, 1);
    expect(cartProvider.quantityOf(testProduct.id), 2);
    expect(cartProvider.subtotal, 3000.0);
  });

  test('Increasing quantity updates subtotal', () {
    cartProvider.addToCart(cheapProduct);
    cartProvider.increaseQuantity(cheapProduct.id);

    expect(cartProvider.quantityOf(cheapProduct.id), 2);
    expect(cartProvider.subtotal, 400.0);
  });

  test('Decreasing quantity does not go below one', () {
    cartProvider.addToCart(cheapProduct);
    cartProvider.decreaseQuantity(cheapProduct.id);

    expect(cartProvider.quantityOf(cheapProduct.id), 1);
    expect(cartProvider.subtotal, 200.0);
  });

  test('Subtotal is calculated correctly for multiple products', () {
    cartProvider.addToCart(testProduct);
    cartProvider.addToCart(cheapProduct);

    expect(cartProvider.subtotal, 1700.0);
    expect(cartProvider.totalItems, 2);
  });

  test('No discount applies when subtotal is exactly ₹2000', () {
    cartProvider.addToCart(testProduct);
    cartProvider.addToCart(cheapProduct);
    cartProvider.increaseQuantity(cheapProduct.id);

    expect(cartProvider.subtotal, 1900.0);
    expect(cartProvider.discount, 0.0);
    expect(cartProvider.totalPrice, 1900.0);
  });

  test('10 percent discount applies when subtotal exceeds ₹2000', () {
    cartProvider.addToCart(testProduct);
    cartProvider.increaseQuantity(testProduct.id);

    expect(cartProvider.subtotal, 3000.0);
    expect(cartProvider.discount, 300.0);
    expect(cartProvider.totalPrice, 2700.0);
  });

  test('Removing a product updates the cart', () {
    cartProvider.addToCart(testProduct);
    cartProvider.addToCart(cheapProduct);

    cartProvider.removeFromCart(testProduct.id);

    expect(cartProvider.containsProduct(testProduct.id), isFalse);
    expect(cartProvider.totalItems, 1);
    expect(cartProvider.subtotal, 200.0);
  });

  test('Clearing the cart removes all products', () {
    cartProvider.addToCart(testProduct);
    cartProvider.addToCart(cheapProduct);

    cartProvider.clearCart();

    expect(cartProvider.isEmpty, isTrue);
    expect(cartProvider.totalItems, 0);
    expect(cartProvider.subtotal, 0.0);
    expect(cartProvider.discount, 0.0);
    expect(cartProvider.totalPrice, 0.0);
  });
}

