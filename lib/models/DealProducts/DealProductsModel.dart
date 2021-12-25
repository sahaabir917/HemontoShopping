// To parse this JSON data, do
//
//     final dealProductsModel = dealProductsModelFromJson(jsonString);

import 'dart:convert';

DealProductsModel dealProductsModelFromJson(String str) => DealProductsModel.fromJson(json.decode(str));

String dealProductsModelToJson(DealProductsModel data) => json.encode(data.toJson());

class DealProductsModel {
  DealProductsModel({
    this.products,
  });

  Products products;

  factory DealProductsModel.fromJson(Map<String, dynamic> json) => DealProductsModel(
    products: Products.fromJson(json["\u0024products"]),
  );

  Map<String, dynamic> toJson() => {
    "\u0024products": products.toJson(),
  };
}

class Products {
  Products({
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
  String prevPageUrl;
  int to;
  int total;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
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
    this.isDeal,
    this.categoryName,
    this.catPhoto,
    this.subcategoryName,
    this.subCatPhoto,
    this.brandName,
    this.brandLogo,
    this.dealId,
    this.dealProductId,
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
  String isDeal;
  String categoryName;
  String catPhoto;
  String subcategoryName;
  String subCatPhoto;
  String brandName;
  String brandLogo;
  String dealId;
  String dealProductId;
  String productId;
  String colorOne;
  String colorTwo;
  String colorThree;
  String pId;
  String imageOne;
  String imageTwo;
  String imageThree;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    isDeal: json["isDeal"],
    categoryName: json["category_name"],
    catPhoto: json["cat_photo"],
    subcategoryName: json["subcategory_name"],
    subCatPhoto: json["sub_cat_photo"],
    brandName: json["brand_name"],
    brandLogo: json["brand_logo"],
    dealId: json["deal_id"],
    dealProductId: json["deal_product_id"],
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
    "isDeal": isDeal,
    "category_name": categoryName,
    "cat_photo": catPhoto,
    "subcategory_name": subcategoryName,
    "sub_cat_photo": subCatPhoto,
    "brand_name": brandName,
    "brand_logo": brandLogo,
    "deal_id": dealId,
    "deal_product_id": dealProductId,
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
