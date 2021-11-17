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
    this.catPhoto,
    this.createdAt,
    this.updatedAt,
    this.isSelected,
  });

  String id;
  String categoryName;
  String status;
  String catPhoto;
  dynamic createdAt;
  dynamic updatedAt;
  bool isSelected;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    categoryName: json["category_name"],
    status: json["status"],
    catPhoto: json["cat_photo"] == null ? null : json["cat_photo"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    isSelected: json["isSelected"] == null ? false : json["isSelected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_name": categoryName,
    "status": status,
    "cat_photo": catPhoto == null ? null : catPhoto,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "isSelected": isSelected == null ? false : isSelected,
  };
}
