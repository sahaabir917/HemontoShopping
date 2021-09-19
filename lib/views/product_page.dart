import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hemontoshoppin/blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'package:hemontoshoppin/blocs/productbloc/product_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  InterstitialAd _interstitialAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  int _coins = 0;
  final _nativeAdController = NativeAdmobController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //new arrived products
            BlocBuilder<ProductBloc, ProductState>(
              bloc: BlocProvider.of<ProductBloc>(context),
              builder: (context, productState) {
                if ((productState is ProductOperationSuccess &&
                    productState.productModel.data.length > 0)) {
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Stack(
                          children: <Widget>[
                            Text(
                              "New Arrived",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 280,
                        padding: EdgeInsets.all(10.0),
                        child: ListView.separated(
                          itemCount: productState.productModel.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // BlocProvider<ProductBloc>(context).of
                                BlocProvider.of<ProductBloc>(context)
                                    .add(SetProductItem(index));
                              },
                              child: Container(
                                width: 230,
                                padding: EdgeInsets.only(right: 0),
                                child: Card(
                                  elevation: 4,
                                  child: Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(40.0),
                                        child: Container(
                                          child: Image.network(
                                              "https://ecotech.xixotech.net/public/" +
                                                  productState
                                                      .productModel
                                                      .data[index]
                                                      .products
                                                      .imageOne),
                                        ),
                                      ),
                                      Positioned(
                                          left: 0,
                                          child: Container(
                                              child: productState.productModel
                                                      .data[index].favourite
                                                  ? IconButton(
                                                      icon: Icon(Icons
                                                          .favorite_border),
                                                      onPressed: () {
                                                        checkLoginStatus(
                                                            context, index);
                                                      },
                                                    )
                                                  : IconButton(
                                                      icon:
                                                          Icon(Icons.favorite),
                                                      onPressed: () {
                                                        checkLoginStatus(
                                                            context, index);
                                                      },
                                                    ))),
                                      Positioned(
                                          right: 0,
                                          child: Container(
                                            child: IconButton(
                                              icon: Icon(Icons.shopping_cart),
                                              onPressed: () {},
                                            ),
                                          )),
                                      Positioned(
                                          bottom: 40,
                                          child: Container(
                                            width: 230,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                child: Text(
                                                  productState
                                                      .productModel
                                                      .data[index]
                                                      .products
                                                      .productName,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          )),
                                      Positioned(
                                          bottom: 10,
                                          child: Container(
                                            width: 230,
                                            height: 25,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "\$" +
                                                      productState
                                                          .productModel
                                                          .data[index]
                                                          .products
                                                          .sellingPrice,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return index % 4 == 0
                                ? Container(
                                    width: 230,
                                    margin: EdgeInsets.all(8),
                                    height: 230,
                                    color: Colors.green,
                                    child: NativeAdmob(
                                      adUnitID: NativeAd.testAdUnitId,
                                      controller: _nativeAdController,
                                      type: NativeAdmobType.full,
                                      loading: Center(
                                          child: CircularProgressIndicator()),
                                      error: Text('failed to load'),
                                    ))
                                : Container();
                          },
                        ),
                      ),
                    ],
                  );
                } else if (productState is LoadedMostPopularProduct) {
                  return Container(
                    child: Text("sad asdasd"),
                  );
                } else if (productState is ProductLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (productState is ProductInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (productState is FetchFailedProduct) {
                  scheduleMicrotask(() => Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => ProductPage())));
                  return CircularProgressIndicator();
                } else if (productState is SetProductItem) {
                  return Container(
                    child: Text("Loading"),
                  );
                } else if (productState is setProductItemSuccess) {
                  scheduleMicrotask(() =>
                      Navigator.of(context).pushNamed("/product_details"));
                  return CircularProgressIndicator();
                } else if (productState is SingleProductLoaded) {
                  // BlocProvider.of<MostPopularBloc>(context)
                  //     .add(FetchMostPopularProduct());
                  // BlocProvider.of<ProductBloc>(context).add(FetchWithoutLoginProduct());
                  return Container(
                    child: Text(productState.toString()),
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            //most popular products
            BlocBuilder<MostPopularBloc, MostPopularState>(
              bloc: BlocProvider.of<MostPopularBloc>(context),
              builder: (context, mostpopularState) {
                if ((mostpopularState is MostPopularProductOperationSuccess &&
                    mostpopularState.productModel.data.length > 0)) {
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Stack(
                          children: <Widget>[
                            Text(
                              "Most Popular",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 280,
                        padding: EdgeInsets.all(10.0),
                        child: ListView.separated(
                          itemCount: mostpopularState.productModel.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 230,
                              padding: EdgeInsets.only(right: 0),
                              child: Card(
                                elevation: 4,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Container(
                                        child: Image.network(
                                            "https://ecotech.xixotech.net/public/" +
                                                mostpopularState
                                                    .productModel
                                                    .data[index]
                                                    .products
                                                    .imageOne),
                                      ),
                                    ),
                                    // Positioned(
                                    //     left: 0,
                                    //     child: Container(
                                    //         child: mostpopularState.productModel
                                    //             .data[index].favourite
                                    //             ? IconButton(
                                    //           icon: Icon(
                                    //               Icons.favorite_border),
                                    //           onPressed: () {
                                    //             // BlocProvider.of<ProductBloc>(
                                    //             //         context)
                                    //             //     .add(LikeProduct(index));
                                    //             // checkLoginStatus(context,index)
                                    //             checkLoginStatus(
                                    //                 context, index);
                                    //           },
                                    //         )
                                    //             : IconButton(
                                    //           icon: Icon(Icons.favorite),
                                    //           onPressed: () {
                                    //             // BlocProvider.of<ProductBloc>(
                                    //             //         context)
                                    //             //     .add(LikeProduct(index));
                                    //             checkLoginStatus(
                                    //                 context, index);
                                    //           },
                                    //         ))),
                                    Positioned(
                                        right: 0,
                                        child: Container(
                                          child: IconButton(
                                            icon: Icon(Icons.shopping_cart),
                                            onPressed: () {},
                                          ),
                                        )),
                                    Positioned(
                                        bottom: 40,
                                        child: Container(
                                          width: 230,
                                          child: Padding(
                                              padding: EdgeInsets.only(top: 0),
                                              child: Text(
                                                mostpopularState
                                                    .productModel
                                                    .data[index]
                                                    .products
                                                    .productName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        )),
                                    Positioned(
                                        bottom: 10,
                                        child: Container(
                                          width: 230,
                                          height: 25,
                                          child: Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                                "\$" +
                                                    mostpopularState
                                                        .productModel
                                                        .data[index]
                                                        .products
                                                        .sellingPrice,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return index % 4 == 0
                                ? Container(
                                    width: 230,
                                    margin: EdgeInsets.all(8),
                                    height: 230,
                                    color: Colors.green,
                                    child: NativeAdmob(
                                      adUnitID: NativeAd.testAdUnitId,
                                      controller: _nativeAdController,
                                      type: NativeAdmobType.full,
                                      loading: Center(
                                          child: CircularProgressIndicator()),
                                      error: Text('failed to load'),
                                    ))
                                : Container();
                          },
                        ),
                      ),
                    ],
                  );
                } else if (mostpopularState is MostPopularProductLoading) {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    checkLoginProduct();
  }

  checkLoginStatus(BuildContext context, int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("isLogin") != null) {
      if (preferences.getBool("isLogin")) {
        BlocProvider.of<ProductBloc>(context).add(LikeProduct(index));
      } else {
        Navigator.pushNamed(context, '/login_page');
      }
    } else {
      Navigator.pushNamed(context, '/login_page');
    }
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
