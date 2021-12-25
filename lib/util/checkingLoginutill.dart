
import 'dart:convert';

import 'package:hemontoshoppin/models/LoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CheckingLoginUtil{
  LoginModel loginModel;
  Future<LoginModel> CheckUserInfo() async {
    getUserInfo().then((value) {
      loginModel = value;
      // print("user : ${loginModel.user.name}");
      return loginModel;
    });
  }

  Future<LoginModel> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> loginModelMap;
    final String userStr = prefs.getString('userData');
    if (userStr != null) {
      loginModelMap = jsonDecode(userStr) as Map<String, dynamic>;
    }

    if (loginModelMap != null) {
      final LoginModel loginModel = LoginModel.fromJson(loginModelMap);
      print(loginModel);
      return loginModel;
    }
    return null;
  }

  Future<bool> isLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin;
    if (sharedPreferences.getBool("isLogin") != null) {
      if (sharedPreferences.getBool("isLogin")) {
        isLogin = true;
      }
      else{
        isLogin = false;
      }
    }
    else{
      isLogin = false;
    }
    return isLogin;
  }
}

