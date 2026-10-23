import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
final ProductModel product;

const ProductDetailsScreen({
super.key,
required this.product,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Product Details'),
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Hero(
tag: 'product-${product.id}',
child: ClipRRect(
borderRadius: BorderRadius.circular(20),
child: Image.network(
product.image,
height: 280,
width: double.infinity,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
height: 280,
width: double.infinity,
color: const Color(0xFFEDE7F6),
alignment: Alignment.center,
child: const Icon(
Icons.image_not_supported_outlined,
size: 64,
),
);
},
),
),
),
const SizedBox(height: 24),
Chip(
label: Text(product.category),
),
const SizedBox(height: 12),
Text(
product.name,
style: Theme.of(context).textTheme.headlineSmall?.copyWith(
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
Text(
'₹${product.price.toStringAsFixed(2)}',
style: Theme.of(context).textTheme.headlineMedium?.copyWith(
color: Theme.of(context).colorScheme.primary,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 20),
Text(
'Description',
style: Theme.of(context).textTheme.titleLarge?.copyWith(
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
Text(
product.description,
style: Theme.of(context).textTheme.bodyLarge,
),
const SizedBox(height: 32),
SizedBox(
width: double.infinity,
child: FilledButton.icon(
onPressed: () {
context.read<CartProvider>().addToCart(product);


              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart'),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Add to Cart'),
          ),
        ),
      ],
    ),
  ),
);


}
}
