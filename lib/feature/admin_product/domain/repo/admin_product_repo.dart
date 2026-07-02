import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/product_model.dart';
import '../../data/models/add_product_request_body.dart';
import '../../data/models/update_product_request_body.dart';

abstract class AdminProductRepo {
  // جلب البيانات
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, ProductModel>> getProductById(int productId);

  // إدارة المنتجات
  Future<Either<Failure, ProductModel>> createProduct(
    AddProductRequestBody body,
  );
  Future<Either<Failure, ProductModel>> updateProduct(
    int productId,
    UpdateProductRequestBody body,
  );
  Future<Either<Failure, void>> deleteProduct(int productId);
  Future<Either<Failure, ProductModel>> toggleProductStatus(int productId);

  // إدارة الأنواع (Variants)
  Future<Either<Failure, void>> deleteVariant(int variantId);
}
