// To parse this JSON data, do
//
//     final failedModel = failedModelFromJson(jsonString);

import 'dart:convert';

FailedModel failedModelFromJson(String str) => FailedModel.fromJson(json.decode(str));

String failedModelToJson(FailedModel data) => json.encode(data.toJson());

class FailedModel {
  FailedModel({
    this.success,
    this.message,
  });

  bool success;
  String message;

  factory FailedModel.fromJson(Map<String, dynamic> json) => FailedModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
