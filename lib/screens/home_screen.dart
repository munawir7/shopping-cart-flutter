
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/category_filter.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    final products = productProvider.filteredProducts;
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ShopEase',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Find your everyday essentials',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          // Dark mode toggle.
          IconButton(
            tooltip: isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),

          // Wishlist button with item count.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              child: Badge(
                label: Text('${wishlistProvider.wishlistCount}'),
                isLabelVisible: wishlistProvider.wishlistCount > 0,
                child: IconButton.filledTonal(
                  tooltip: 'Wishlist',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const WishlistScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.favorite_border),
                ),
              ),
            ),
          ),

          // Cart button with item count.
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Badge(
                label: Text('${cartProvider.totalItems}'),
                isLabelVisible: cartProvider.totalItems > 0,
                child: IconButton.filledTonal(
                  tooltip: 'Shopping Cart',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search field.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                onChanged: productProvider.searchProducts,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: productProvider.searchQuery.isNotEmpty
                      ? IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            productProvider.searchProducts('');
                          },
                          icon: const Icon(Icons.close),
                        )
                      : null,
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Categories and sorting.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Categories',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: productProvider.sortOption,
                          borderRadius: BorderRadius.circular(12),
                          dropdownColor: colorScheme.surface,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                          ),
                          hint: const Text('Sort'),
                          items: const [
                            DropdownMenuItem(
                              value: 'None',
                              child: Text('Default'),
                            ),
                            DropdownMenuItem(
                              value: 'Price: Low to High',
                              child: Text('Price: Low to High'),
                            ),
                            DropdownMenuItem(
                              value: 'Price: High to Low',
                              child: Text('Price: High to Low'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              productProvider.sortProducts(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CategoryFilter(
                    categories: productProvider.categories,
                    selectedCategory: productProvider.selectedCategory,
                    onCategorySelected: productProvider.filterByCategory,
                  ),
                ],
              ),
            ),

            // Product heading.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Discover Products',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${products.length} items',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Product grid.
            Expanded(
              child: products.isEmpty
                  ? _buildEmptyState(context, productProvider)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.58,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => ProductDetailsScreen(
                                  product: product,
                                ),
                              ),
                            );
                          },
                          onAddToCart: () {
                            context.read<CartProvider>().addToCart(product);

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.name} added to cart',
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ProductProvider provider,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try another search or change the selected category.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: provider.resetFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

