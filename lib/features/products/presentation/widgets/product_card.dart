
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product_model.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final isFavorite = wishlistProvider.isInWishlist(product.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image and wishlist button
            Stack(
              children: [
                Hero(
                  tag: 'product-${product.id}',
                  child: Image.network(
                    product.image,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.95),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: isFavorite
                          ? 'Remove from wishlist'
                          : 'Add to wishlist',
                      onPressed: () {
                        wishlistProvider.toggleWishlist(product);

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? '${product.name} removed from wishlist'
                                    : '${product.name} added to wishlist',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onAddToCart,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

