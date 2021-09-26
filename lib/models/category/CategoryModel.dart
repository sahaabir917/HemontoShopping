// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.data,
  });

  List<Datum> data;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.categoryName,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isSelected,
  });

  String id;
  String categoryName;
  String status;
  dynamic createdAt;
  dynamic updatedAt;
  bool isSelected;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    categoryName: json["category_name"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    isSelected: json["is_selected"] == null ? false : json["is_selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_name": categoryName,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_selected": isSelected == null ? false : isSelected,
  };
}
