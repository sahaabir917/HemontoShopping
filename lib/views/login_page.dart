import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/views/product_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login page"),
      ),
      body: ListView(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    obscureText: false,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        hintText: "Enter Your Email",
                        hintStyle: TextStyle(color: Colors.white70),
                        icon: Icon(Icons.lock)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter Your Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        hintStyle: TextStyle(color: Colors.white70),
                        icon: Icon(Icons.remove_red_eye_outlined)),
                  ),
                  RaisedButton(
                      child: Text("login"),
                      color: Colors.redAccent,
                      onPressed: () {
                        var email = emailController.text;
                        var password = passwordController.text;
                        BlocProvider.of<LoginBloc>(context)
                            .add(FetchLogin(email, password));
                      }),
                  BlocBuilder<LoginBloc, LoginState>(
                    bloc: BlocProvider.of<LoginBloc>(context),
                    builder: (context, loginState) {
                      if (loginState is LoginInitial) {
                        return Container(
                          height: 10,
                          width: 10,
                          child: Text(
                            "dklajd",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (loginState is checkingLogin) {
                        return CircularProgressIndicator();
                      } else if (loginState is LoginInOperationSuccess) {
                        scheduleMicrotask(() => Navigator.of(context)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ProductPage()),
                                (Route<dynamic> route) => false));
                        return CircularProgressIndicator();
                      } else if (loginState is LoginFailed) {
                        return Text(loginState.failedModel.message != null
                            ? loginState.failedModel.message
                            : "Login Failed");
                        //  Fluttertoast.showToast(
                        //      msg: 'You cannot change the answer again!',
                        //      toastLength: Toast.LENGTH_SHORT,
                        //      gravity: ToastGravity.BOTTOM,
                        //      backgroundColor: Colors.lightBlueAccent,
                        //      textColor: Colors.white);
                        //  return Container();
                      } else if (loginState is NoLogin) {
                        return Container(
                          child: Text(""),
                        );
                      } else if (loginState is AlreadyLogin) {
                        return Container(
                          child: Text(""),
                        );
                      } else {
                        print(loginState.toString());
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  gotoProductPage() {
    Navigator.of(context).pushNamed("/product_page");
  }
}
