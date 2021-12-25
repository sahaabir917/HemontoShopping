import 'dart:convert';

import 'package:hemontoshoppin/models/LoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static SharedPreferences pref;

  void clearData() async {
    pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void setUserData(LoginModel userData) async {
    pref = await SharedPreferences.getInstance();
    pref.setString("userData", jsonEncode(userData));
    pref.commit();
  }

  void setIsLoggedIn(bool isLogin) async {
    pref = await SharedPreferences.getInstance();
    pref.setBool("isLogin", isLogin);
    pref.commit();
  }

  void setJwtToken(String token) async{
    pref = await SharedPreferences.getInstance();
    pref.setString("jwtToken", token);
    pref.commit();
  }

  void setUserId(String id) async{
    pref = await SharedPreferences.getInstance();
    pref.setString("user_id",id);
    pref.commit();
  }

  void LogoutData() async {
    pref = await SharedPreferences.getInstance();
    // pref.setString("jwtToken", null);
    pref.remove("jwtToken");
    // pref.setString("user_id",null);
    pref.remove("user_id");
    pref.setBool("isLogin", false);
    setIsLoggedIn(false);
    pref.remove("userData");
    pref.commit();
  }

}