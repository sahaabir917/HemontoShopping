// To parse this JSON data, do
//
//     final dealModel = dealModelFromJson(jsonString);

import 'dart:convert';

DealModel dealModelFromJson(String str) => DealModel.fromJson(json.decode(str));

String dealModelToJson(DealModel data) => json.encode(data.toJson());

class DealModel {
  DealModel({
    this.deals,
  });

  List<Deal> deals;

  factory DealModel.fromJson(Map<String, dynamic> json) => DealModel(
    deals: List<Deal>.from(json["deals"].map((x) => Deal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "deals": List<dynamic>.from(deals.map((x) => x.toJson())),
  };
}

class Deal {
  Deal({
    this.id,
    this.dealName,
    this.dealDescription,
    this.dealPicture,
    this.dealStatus,
    this.dealType,
    this.isSliding,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String dealName;
  String dealDescription;
  String dealPicture;
  String dealStatus;
  String dealType;
  String isSliding;
  dynamic createdAt;
  dynamic updatedAt;

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
    id: json["id"],
    dealName: json["deal_name"],
    dealDescription: json["deal_description"],
    dealPicture: json["deal_picture"],
    dealStatus: json["deal_status"],
    dealType: json["deal_type"],
    isSliding: json["isSliding"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "deal_name": dealName,
    "deal_description": dealDescription,
    "deal_picture": dealPicture,
    "deal_status": dealStatus,
    "deal_type": dealType,
    "isSliding": isSliding,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
