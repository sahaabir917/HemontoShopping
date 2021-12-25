// To parse this JSON data, do
//
//     final pendingOrderProductModel = pendingOrderProductModelFromJson(jsonString);

import 'dart:convert';

PendingOrderProductModel pendingOrderProductModelFromJson(String str) => PendingOrderProductModel.fromJson(json.decode(str));

String pendingOrderProductModelToJson(PendingOrderProductModel data) => json.encode(data.toJson());

class PendingOrderProductModel {
  PendingOrderProductModel({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory PendingOrderProductModel.fromJson(Map<String, dynamic> json) => PendingOrderProductModel(
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  Datum({
    this.id,
    this.orderUserId,
    this.generateOrdertitle,
    this.orderCartId,
    this.orderStatus,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.productId,
    this.cartQuantity,
    this.isOrdered,
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
    this.isDeal,
    this.pId,
    this.imageOne,
    this.imageTwo,
    this.imageThree,
  });

  String id;
  String orderUserId;
  String generateOrdertitle;
  String orderCartId;
  String orderStatus;
  dynamic createdAt;
  dynamic updatedAt;
  String userId;
  String productId;
  String cartQuantity;
  String isOrdered;
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
  dynamic isDeal;
  String pId;
  String imageOne;
  String imageTwo;
  String imageThree;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    orderUserId: json["order_user_id"],
    generateOrdertitle: json["generate_ordertitle"],
    orderCartId: json["order_cart_id"],
    orderStatus: json["order_status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    userId: json["user_id"],
    productId: json["product_id"],
    cartQuantity: json["cart_quantity"],
    isOrdered: json["isOrdered"],
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
    isDeal: json["isDeal"],
    pId: json["p_id"],
    imageOne: json["image_one"],
    imageTwo: json["image_two"],
    imageThree: json["image_three"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_user_id": orderUserId,
    "generate_ordertitle": generateOrdertitle,
    "order_cart_id": orderCartId,
    "order_status": orderStatus,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user_id": userId,
    "product_id": productId,
    "cart_quantity": cartQuantity,
    "isOrdered": isOrdered,
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
    "isDeal": isDeal,
    "p_id": pId,
    "image_one": imageOne,
    "image_two": imageTwo,
    "image_three": imageThree,
  };
}
