// To parse this JSON data, do
//
//     final userCartModel = userCartModelFromJson(jsonString);

import 'dart:convert';

UserCartModel userCartModelFromJson(String str) => UserCartModel.fromJson(json.decode(str));

String userCartModelToJson(UserCartModel data) => json.encode(data.toJson());

class UserCartModel {
  UserCartModel({
    this.data,
    this.totalPrice,
  });

  List<Datum> data;
  int totalPrice;

  factory UserCartModel.fromJson(Map<String, dynamic> json) => UserCartModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total_price": totalPrice,
  };
}

class Datum {
  Datum({
    this.products,
    this.favourite,
    this.cartQuantity,
  });

  Products products;
  bool favourite;
  int cartQuantity;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    products: Products.fromJson(json["products"]),
    favourite: json["favourite"],
    cartQuantity: json["cart_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "products": products.toJson(),
    "favourite": favourite,
    "cart_quantity": cartQuantity,
  };
}

class Products {
  Products({
    this.id,
    this.userId,
    this.productId,
    this.cartQuantity,
    this.isOrdered,
    this.createdAt,
    this.updatedAt,
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
    this.categoryName,
    this.subcategoryName,
    this.brandName,
    this.brandLogo,
    this.colorOne,
    this.colorTwo,
    this.colorThree,
    this.pId,
    this.imageOne,
    this.imageTwo,
    this.imageThree,
  });

  String id;
  String userId;
  String productId;
  String cartQuantity;
  String isOrdered;
  dynamic createdAt;
  dynamic updatedAt;
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
  dynamic videoLink;
  String status;
  String categoryName;
  String subcategoryName;
  String brandName;
  String brandLogo;
  String colorOne;
  String colorTwo;
  String colorThree;
  String pId;
  String imageOne;
  String imageTwo;
  String imageThree;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    cartQuantity: json["cart_quantity"],
    isOrdered: json["isOrdered"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
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
    categoryName: json["category_name"],
    subcategoryName: json["subcategory_name"],
    brandName: json["brand_name"],
    brandLogo: json["brand_logo"],
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
    "user_id": userId,
    "product_id": productId,
    "cart_quantity": cartQuantity,
    "isOrdered": isOrdered,
    "created_at": createdAt,
    "updated_at": updatedAt,
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
    "category_name": categoryName,
    "subcategory_name": subcategoryName,
    "brand_name": brandName,
    "brand_logo": brandLogo,
    "color_one": colorOne,
    "color_two": colorTwo,
    "color_three": colorThree,
    "p_id": pId,
    "image_one": imageOne,
    "image_two": imageTwo,
    "image_three": imageThree,
  };
}
