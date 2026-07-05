import 'package:dartz/dartz.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_error_handler.dart';

abstract class ProductRepo {
  Future<Either<Failure, ProductModel>> getProductDetails(int productId);
}
