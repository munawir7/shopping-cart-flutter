import 'package:shopping_cart_app/features/products/data/datasources/product_data.dart';
import 'package:shopping_cart_app/features/products/domain/repositories/product_repositories.dart';

import '../../domain/models/product_model.dart';


class ProductRepositoryImpl implements ProductRepository {
@override
List<ProductModel> getProducts() {
return ProductData.products;
}
}
