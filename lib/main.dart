import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/blocs/categorybloc/category_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'package:hemontoshoppin/views/category/category_page.dart';
import 'package:hemontoshoppin/views/login_page.dart';
import 'package:hemontoshoppin/views/product_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'blocs/productbloc/product_bloc.dart';
import 'blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'views/productviews/ProductDetailsPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(create: (context) => ProductBloc() ,),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc() ,),
        BlocProvider<MostPopularBloc>(create: (context) => MostPopularBloc() ,),
        BlocProvider<CategoryBloc>(create:(context) => CategoryBloc(),),
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
          "/product_page" : (context) => ProductPage(),
          "/product_details" : (context) => ProductDetailsPage(),
          "/category_page" : (context) => CategoryPage(),
        },
      ),
    );
  }
}



