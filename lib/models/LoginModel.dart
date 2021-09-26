// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.success,
    this.token,
    this.user,
  });

  bool success;
  String token;
  User user;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    success: json["success"]?? "",
    token: json["token"]?? "",
    user: User.fromJson(json["user"]?? ""),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"]?? "",
    name: json["name"]?? "",
    email: json["email"]?? "",
    emailVerifiedAt: json["email_verified_at"]?? "",
    createdAt: DateTime.parse(json["created_at"]?? ""),
    updatedAt: DateTime.parse(json["updated_at"]?? ""),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
