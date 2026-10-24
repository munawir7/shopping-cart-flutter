
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../checkout/presentation/screens/checkout_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmRemove(
    BuildContext context,
    CartProvider cartProvider,
    int productId,
    String productName,
  ) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Item?'),
          content: Text(
            'Do you want to remove "$productName" from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldRemove == true && context.mounted) {
  cartProvider.removeFromCart(productId);
}
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!cartProvider.isEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${cartProvider.totalItems} items',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
      body: cartProvider.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];

                      return CartItemCard(
                        item: item,
                        onIncrease: () {
                          cartProvider.increaseQuantity(item.product.id);
                        },
                        onDecrease: () {
                          cartProvider.decreaseQuantity(item.product.id);
                        },
                        onRemove: () {
                          _confirmRemove(
                            context,
                            cartProvider,
                            item.product.id,
                            item.product.name,
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildCartSummary(context, cartProvider),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our products and add your favorites!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(
    BuildContext context,
    CartProvider cartProvider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _summaryRow(
              'Total items',
              '${cartProvider.totalItems}',
            ),
            const SizedBox(height: 8),
            _summaryRow(
              'Subtotal',
              '₹${cartProvider.subtotal.toStringAsFixed(2)}',
            ),
           // const Divider(height: 24),
          
if (cartProvider.discount > 0) ...[
  _summaryRow(
    'Discount (10%)',
    '-₹${cartProvider.discount.toStringAsFixed(2)}',
  ),
  const SizedBox(height: 8),
],
const Divider(height: 24),
_summaryRow(
  'Total',
  '₹${cartProvider.totalPrice.toStringAsFixed(2)}',
  isTotal: true,
),


            const SizedBox(height: 16),
            SizedBox(
  width: double.infinity,
  child: FilledButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const CheckoutScreen(),
        ),
      );
    },
    icon: const Icon(Icons.payment),
    label: const Text('Proceed to Checkout'),
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 17 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 19 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

