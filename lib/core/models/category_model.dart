import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final int? id;
  final String? name;
  final String? image;

  CategoryModel({this.id, this.name, this.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
// لا تنسَ تشغيل أمر: flutter pub run build_runner build --delete-conflicting-outputs