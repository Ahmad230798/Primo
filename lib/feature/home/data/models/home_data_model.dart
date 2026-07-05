import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/models/offer_model.dart';
import 'package:primo/core/models/product_model.dart';

class HomeDataModel {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final List<OfferModel> offers;

  HomeDataModel({
    required this.categories,
    required this.products,
    required this.offers,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
