import 'dart:convert';

import 'package:hemontoshoppin/SharedPreference/PreferenceHelper.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/LoginModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static var client = http.Client();
  static PreferenceHelper preferenceHelper = new PreferenceHelper();
  String jwttoken;

  ApiService() {
    getJwtToken().then((value) {
      jwttoken = value;
      print(jwttoken);
    });
  }

  Future<String> getJwtToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwttoken = sharedPreferences.getString("jwtToken");
    return jwttoken;
  }

  Future<ProductModel> getProductWithOutLogin() async {
    const _baseUrl = "ecotech.xixotech.net";
    const String _path = "/public/api/productswithoutlogin";
    Uri uri = Uri.http(_baseUrl, _path);
    Response response = await http.get(uri);
    if (response.statusCode == 200) {
      ProductModel productModel = productModelFromJson(response.body);
      print(response.body);
      return productModel;
    }
  }

  Future<dynamic> getProductWithLogin(String token, String userId) async {

      var body = {"user_id":userId};

      var response = await client.post(
          Uri.parse('https://ecotech.xixotech.net/public/api/productwithlogin'),
          headers: {
            'Authorization': "Bearer ${token}",
            "Content-Type": "application/json"
          },
        body: jsonEncode(body),
          );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        ProductModel productModel = productModelFromJson(response.body);
        print(jsonString);
        return productModel;
      } else if(response.statusCode == 401){
        var jsonString = {"status" : false, "message" : "session out"};
        FailedModel failedModel = FailedModel.fromJson(jsonString);
        print(response.statusCode);
        preferenceHelper.setJwtToken(null);
        preferenceHelper.setIsLoggedIn(false);
        return failedModel;
      }
      else{
        print(response.statusCode);
      }



  }

  Future<dynamic> UserLogin(String username, String password) async {

    var body = {"email": "${username}", "password": "${password}"};
    var response = await client.post(
        Uri.parse('https://ecotech.xixotech.net/public/api/user-login'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      LoginModel loginModel = loginModelFromJson(response.body);
      print(response.body);
      preferenceHelper.setUserId(loginModel.user.id.toString());
      preferenceHelper.setJwtToken(loginModel.token);
      preferenceHelper.setIsLoggedIn(true);
      return loginModel;
    } else {
      var jsonString = response.body;
      FailedModel failedModel = failedModelFromJson(jsonString);
      preferenceHelper.setJwtToken(null);
      preferenceHelper.setIsLoggedIn(false);
      return failedModel;
    }
  }

  Future<ProductModel> getMostPopularProduct() async {
    const _baseUrl = "ecotech.xixotech.net";
    const String _path = "/public/api/mostpopularProducts";
    Uri uri = Uri.http(_baseUrl, _path);
    Response response = await http.get(uri);
    if (response.statusCode == 200) {
      ProductModel productModel = productModelFromJson(response.body);
      print(response.body);
      return productModel;
    }
  }
}
