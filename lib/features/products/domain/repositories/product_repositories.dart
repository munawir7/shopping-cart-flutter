import '../models/product_model.dart';

abstract class ProductRepository {
List<ProductModel> getProducts();
}
