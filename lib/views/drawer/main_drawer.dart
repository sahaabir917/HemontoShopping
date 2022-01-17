import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/SharedPreference/PreferenceHelper.dart';
import 'package:hemontoshoppin/blocs/favbloc/favbloc.dart';
import 'package:hemontoshoppin/blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'package:hemontoshoppin/models/LoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  LoginModel loginModel;
  bool isLogin = false;
  var fav_color = false;
  static PreferenceHelper preferenceHelper = new PreferenceHelper();

  @override
  Widget build(BuildContext context) {
    CheckUserInfo();
    return Drawer(
      child: Container(
        color: (loginModel == null || loginModel == "")
            ? Colors.blueAccent
            : Colors.blueAccent,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Container(
                // color: Color(hexColor("#ECECEC")),
                color:
                    loginModel == null ? Colors.deepPurple : Colors.deepPurple,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/defaultprofilepic.jpg"),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        loginModel == null ? "" : loginModel.user.name,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        loginModel == null
                            ? ""
                            : loginModel.user.email == null
                                ? ""
                                : loginModel.user.email,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              color: Colors.greenAccent,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                child: Container(
                  height: 20,
                  child: InkWell(
                    onTap: () {
                      if (loginModel != null) {

                      } else {
                        Fluttertoast.showToast(
                            msg: "You have to login first",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1);
                        Navigator.pushNamed(context, "/login_page");
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/fav.png",
                          height: 25,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "My Favourite",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              color: Colors.greenAccent,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                child: Container(
                  height: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/category_page");
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.widgets_sharp,size: 25,),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "All Category",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
                // visible: loginModel == null?false : true,
                visible: true,
                child: Container(
                  height: 40,
                  color: Colors.greenAccent,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                    child: Container(
                      height: 20,
                      child: InkWell(
                        onTap: () {
                          if (loginModel != null) {
                            Navigator.pushNamed(context, "/my_orders");
                          }
                          else {
                            Fluttertoast.showToast(
                                msg: "You have to login first",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1);
                            Navigator.pushNamed(context, "/login_page");
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/order2.png",
                              height: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "My Orders",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            SizedBox(height: 20,),
            Container(
              height: 40,
              color: Colors.greenAccent,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                child: Container(
                  height: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/cart_page");
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.shopping_cart,size: 25.0,color:Colors.black),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "My Cart",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              color: Colors.greenAccent,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                child: Container(
                  height: 20,
                  child: InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, "/category_page");
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.share,size: 25.0,color:Colors.black),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(Icons.facebook,size: 40,color: Colors.white,),
                  FaIcon(FontAwesomeIcons.instagram,size: 40,color: Colors.white,),
                  FaIcon(FontAwesomeIcons.twitter,size: 40,color: Colors.white,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {

    //use the checkingloginUtill

    CheckUserInfo().then((value) {
      setState(() {});
    });
  }

  Future<LoginModel> CheckUserInfo() async {
    getUserInfo().then((value) {
      loginModel = value;
      // print("user : ${loginModel.user.name}");
      return loginModel;
    });
  }

  Future<bool> checkLoginStatus() async {
    checkLoginProduct().then((value) {
      isLogin = value;
      return isLogin;
    });
  }
}

Future<bool> checkLoginProduct() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getBool("isLogin") != null) {
    if (preferences.getBool("isLogin")) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
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

int hexColor(String color) {
  String newColor = '0xff' + color;
  newColor = newColor.replaceAll("#", '');
  int finalColor = int.parse(newColor);
  return finalColor;
}
