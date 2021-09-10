import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/views/login_page.dart';
import 'package:hemontoshoppin/views/product_page.dart';

import 'blocs/productbloc/product_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(create: (context) => ProductBloc() ,),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc() ,),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductPage(),
        routes: {
          "/login_page" :(context) => LoginPage(),
        },
      ),
    );
  }
}

