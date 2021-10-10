// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.data,
  });

  List<Datum> data;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.products,
    this.favourite,
  });

  Products products;
  bool favourite;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    products: Products.fromJson(json["products"]),
    favourite: json["favourite"],
  );

  Map<String, dynamic> toJson() => {
    "products": products.toJson(),
    "favourite": favourite,
  };
}

class Products {
  Products({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.brandId,
    this.productName,
    this.productCode,
    this.productQuantity,
    this.productDetails,
    this.productSize,
    this.sellingPrice,
    this.discountPrice,
    this.videoLink,
    this.status,
    this.isPackage,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.subcategoryName,
    this.brandName,
    this.brandLogo,
    this.productId,
    this.colorOne,
    this.colorTwo,
    this.colorThree,
    this.pId,
    this.imageOne,
    this.imageTwo,
    this.imageThree,
  });

  String id;
  String categoryId;
  String subcategoryId;
  String brandId;
  String productName;
  String productCode;
  String productQuantity;
  String productDetails;
  String productSize;
  String sellingPrice;
  String discountPrice;
  String videoLink;
  String status;
  String isPackage;
  dynamic createdAt;
  dynamic updatedAt;
  String categoryName;
  String subcategoryName;
  String brandName;
  String brandLogo;
  String productId;
  String colorOne;
  String colorTwo;
  String colorThree;
  String pId;
  String imageOne;
  String imageTwo;
  String imageThree;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    brandId: json["brand_id"],
    productName: json["product_name"],
    productCode: json["product_code"],
    productQuantity: json["product_quantity"],
    productDetails: json["product_details"],
    productSize: json["product_size"],
    sellingPrice: json["selling_price"],
    discountPrice: json["discount_price"],
    videoLink: json["video_link"],
    status: json["status"],
    isPackage: json["isPackage"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    categoryName: json["category_name"],
    subcategoryName: json["subcategory_name"],
    brandName: json["brand_name"],
    brandLogo: json["brand_logo"],
    productId: json["product_id"],
    colorOne: json["color_one"],
    colorTwo: json["color_two"],
    colorThree: json["color_three"],
    pId: json["p_id"],
    imageOne: json["image_one"],
    imageTwo: json["image_two"],
    imageThree: json["image_three"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "brand_id": brandId,
    "product_name": productName,
    "product_code": productCode,
    "product_quantity": productQuantity,
    "product_details": productDetails,
    "product_size": productSize,
    "selling_price": sellingPrice,
    "discount_price": discountPrice,
    "video_link": videoLink,
    "status": status,
    "isPackage": isPackage,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "category_name": categoryName,
    "subcategory_name": subcategoryName,
    "brand_name": brandName,
    "brand_logo": brandLogo,
    "product_id": productId,
    "color_one": colorOne,
    "color_two": colorTwo,
    "color_three": colorThree,
    "p_id": pId,
    "image_one": imageOne,
    "image_two": imageTwo,
    "image_three": imageThree,
  };
}
