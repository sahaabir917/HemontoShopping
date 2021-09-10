import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/productbloc/product_bloc.dart';
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
      body: Container(
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
              RaisedButton(onPressed: () {
                var email = emailController.text;
                var password = passwordController.text;
                BlocProvider.of<LoginBloc>(context).add(FetchLogin(email, password));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
