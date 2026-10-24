import 'package:flutter/foundation.dart';
import 'package:shopping_cart_app/features/products/domain/repositories/product_repositories.dart';
import 'package:shopping_cart_app/features/products/domain/repositories/product_repository_impl.dart';


import '../../domain/models/product_model.dart';


class ProductProvider extends ChangeNotifier {
final ProductRepository _productRepository;

late final List<ProductModel> _products;

ProductProvider({ProductRepository? productRepository})
: _productRepository =
productRepository ?? ProductRepositoryImpl() {
_products = _productRepository.getProducts();
}

// Current search query.
String _searchQuery = '';

// Selected category. "All" displays every category.
String _selectedCategory = 'All';

// Current price sorting option.
String _sortOption = 'None';

// Getters.
List<ProductModel> get products => List.unmodifiable(_products);

String get searchQuery => _searchQuery;

String get selectedCategory => _selectedCategory;

String get sortOption => _sortOption;

// Available categories.
List<String> get categories {
final categorySet =
_products.map((product) => product.category).toSet();


return ['All', ...categorySet.toList()..sort()];


}

// Products after applying search, category filtering, and sorting.
List<ProductModel> get filteredProducts {
final result = _products.where((product) {
final matchesSearch = product.name
.toLowerCase()
.contains(_searchQuery.trim().toLowerCase());


  final matchesCategory = _selectedCategory == 'All' ||
      product.category == _selectedCategory;

  return matchesSearch && matchesCategory;
}).toList();

if (_sortOption == 'Price: Low to High') {
  result.sort((a, b) => a.price.compareTo(b.price));
} else if (_sortOption == 'Price: High to Low') {
  result.sort((a, b) => b.price.compareTo(a.price));
}

return result;


}

// Update the search query.
void searchProducts(String query) {
if (_searchQuery == query) return;


_searchQuery = query;
notifyListeners();


}

// Filter products by category.
void filterByCategory(String category) {
if (!categories.contains(category)) return;
if (_selectedCategory == category) return;


_selectedCategory = category;
notifyListeners();


}

// Sort products by price.
void sortProducts(String option) {
const validOptions = [
'None',
'Price: Low to High',
'Price: High to Low',
];


if (!validOptions.contains(option)) return;
if (_sortOption == option) return;

_sortOption = option;
notifyListeners();


}

// Reset search, category, and sorting.
void resetFilters() {
_searchQuery = '';
_selectedCategory = 'All';
_sortOption = 'None';


notifyListeners();


}
}
