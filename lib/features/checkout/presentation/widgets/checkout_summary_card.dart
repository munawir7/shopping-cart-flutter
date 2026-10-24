
import 'package:flutter/material.dart';

import '../../../cart/presentation/providers/cart_provider.dart';

class CheckoutSummaryCard extends StatelessWidget {
  final CartProvider cartProvider;

  const CheckoutSummaryCard({
    super.key,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = cartProvider.discount > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            _priceRow('Total items', '${cartProvider.totalItems}'),
            const SizedBox(height: 12),
            _priceRow(
              'Subtotal',
              '₹${cartProvider.subtotal.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _priceRow(
              'Discount',
              hasDiscount
                  ? '- ₹${cartProvider.discount.toStringAsFixed(2)}'
                  : '₹0.00',
              valueColor: hasDiscount ? Colors.green : null,
            ),
            if (hasDiscount) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '🎉 You saved 10% on your order!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'Spend more than ₹2,000 to receive a 10% discount.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
            const Divider(height: 28),
            _priceRow(
              'Final Total',
              '₹${cartProvider.totalPrice.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 17 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
