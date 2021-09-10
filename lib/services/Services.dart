
import 'dart:convert';

import 'package:hemontoshoppin/models/LoginModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService{
  static var client = http.Client();
  Future<ProductModel> getProductWithOutLogin() async{
     const _baseUrl = "ecotech.xixotech.net";
     const String _path = "/public/api/productswithoutlogin";
    Uri uri = Uri.http(_baseUrl, _path);
    Response response = await http.get(uri);
    if(response.statusCode ==200){
      ProductModel productModel = productModelFromJson(response.body);
      print(response.body);
      return productModel;
    }
  }

   Future<LoginModel> UserLogin(String username, String password) async{
     // const _baseUrl = "ecotech.xixotech.net";
     // const String _path = "/public/api/user-login";
     // Uri uri = Uri.http(_baseUrl, _path);
     // var body = {"email": "${username}", "password": "${password}"};
     //
     // Response response = await http.post(uri,body: jsonEncode(body),headers: {"Content-Type": "application/json"});
     // if(response.statusCode ==200){
     //   LoginModel loginModel = loginModelFromJson(response.body);
     //   print(response.body);
     //   return loginModel;
     // }
     // else{
     //   print(response.statusCode);
     //   print(response.body);
     // }


     var body = {"email": "${username}", "password": "${password}"};
     var response = await client.post(
         Uri.parse('https://ecotech.xixotech.net/public/api/user-login'),
         body: jsonEncode(body),
         headers: {"Content-Type": "application/json"});

     if(response.statusCode ==200){
       LoginModel loginModel = loginModelFromJson(response.body);
         print(response.body);
         return loginModel;
     }
     else{
       print(response.body);
       print(response.statusCode);
     }

   }
}