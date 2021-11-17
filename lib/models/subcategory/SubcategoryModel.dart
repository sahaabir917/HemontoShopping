// To parse this JSON data, do
//
//     final subcategoryModel = subcategoryModelFromJson(jsonString);

import 'dart:convert';

SubcategoryModel subcategoryModelFromJson(String str) => SubcategoryModel.fromJson(json.decode(str));

String subcategoryModelToJson(SubcategoryModel data) => json.encode(data.toJson());

class SubcategoryModel {
  SubcategoryModel({
    this.subcategories,
  });

  List<Subcategory> subcategories;

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) => SubcategoryModel(
    subcategories: List<Subcategory>.from(json["subcategories"].map((x) => Subcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
  };
}

class Subcategory {
  Subcategory({
    this.subId,
    this.categoryId,
    this.subcategoryName,
    this.subCatPhoto,
  });

  String subId;
  String categoryId;
  String subcategoryName;
  String subCatPhoto;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    subId: json["sub_id"],
    categoryId: json["category_id"],
    subcategoryName: json["subcategory_name"],
    subCatPhoto: json["sub_cat_photo"] == null ? null : json["sub_cat_photo"],
  );

  Map<String, dynamic> toJson() => {
    "sub_id": subId,
    "category_id": categoryId,
    "subcategory_name": subcategoryName,
    "sub_cat_photo": subCatPhoto == null ? null : subCatPhoto,
  };
}
