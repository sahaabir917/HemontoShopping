import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hemontoshoppin/blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'package:hemontoshoppin/blocs/productbloc/product_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key key}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  InterstitialAd _interstitialAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  int _coins = 0;
  final _nativeAdController = NativeAdmobController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        checkLoginProduct();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text("All Product"),
                excludeHeaderSemantics: true,
                expandedHeight: 50.0,
                forceElevated: innerBoxIsScrolled,
              ),
            ];
          },
          body: BlocBuilder<ProductBloc, ProductState>(
            bloc: BlocProvider.of<ProductBloc>(context),
            builder: (context, productState) {
              if (productState is ProductLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (productState is ProductInitial) {
                BlocProvider.of<ProductBloc>(context).add(getProductItem());
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (productState is SingleProductLoaded) {
                return Padding(
                  padding: EdgeInsets.all(2),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                              "https://ecotech.xixotech.net/public/" +
                                  productState.products.imageOne,
                              fit: BoxFit.cover,
                              ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.zero,
                                  top: Radius.circular(40)),
                              color: Colors.white),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20,),
                                Center(
                                  child: Container(
                                    width: 150,
                                    height: 7,
                                    decoration: BoxDecoration(
                                        color:Colors.red[50],
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Text(productState.products.productName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                                Padding(
                                    padding: EdgeInsets.all(30),
                                    child: Html(
                                      data:
                                          productState.products.productDetails,
                                    )),
                                Text(productState.products.sellingPrice),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                          height: size.height * .6,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                  child: Text(productState.toString()),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    BlocProvider.of<ProductBloc>(context).add(getProductItem());
  }

  void checkLoginProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool("isLogin") != null) {
      if (preferences.getBool("isLogin")) {
        BlocProvider.of<ProductBloc>(context).add(FetchWithLoginProduct());
      } else {
        BlocProvider.of<MostPopularBloc>(context)
            .add(FetchMostPopularProduct());
        BlocProvider.of<ProductBloc>(context).add(FetchWithoutLoginProduct());
      }
    } else {
      BlocProvider.of<ProductBloc>(context).add(FetchWithoutLoginProduct());
      BlocProvider.of<MostPopularBloc>(context).add(FetchMostPopularProduct());
    }
  }
}
