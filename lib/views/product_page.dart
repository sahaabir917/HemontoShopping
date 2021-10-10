import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hemontoshoppin/SharedPreference/PreferenceHelper.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'package:hemontoshoppin/blocs/productbloc/product_bloc.dart';
import 'package:hemontoshoppin/blocs/productdetailsbloc/product_details_bloc.dart';
import 'package:hemontoshoppin/bottomsheet/CustomCartBottomSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer/main_drawer.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  InterstitialAd _interstitialAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  int _coins = 0;
  bool isLogin = true;
  final _nativeAdController = NativeAdmobController();
  static PreferenceHelper preferenceHelper = new PreferenceHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
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
              actions: <Widget>[
                BlocBuilder<LoginBloc, LoginState>(
                    bloc: BlocProvider.of<LoginBloc>(context),
                    builder: (context, loginState) {
                      if (loginState is NoLogin) {
                        return Container(
                          height: 2,
                          child: Text(""),
                        );
                      } else if (loginState is AlreadyLogin) {
                        return Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.logout),
                                onPressed: () {
                                  isLogin = false;
                                  preferenceHelper.LogoutData();
                                  BlocProvider.of<LoginBloc>(context)
                                      .add(SetLoginStatus(false));
                                  BlocProvider.of<MostPopularBloc>(context)
                                      .add(FetchMostPopularProduct());
                                  BlocProvider.of<ProductBloc>(context)
                                      .add(FetchWithoutLoginProduct());
                                }),

                            BlocBuilder<CartBloc, CartState>(
                                bloc: BlocProvider.of<CartBloc>(context),
                                builder: (context, cartState) {
                                  if (cartState is CartInitial) {
                                    return Stack(
                                      children: <Widget>[
                                        IconButton(
                                          icon:
                                              Icon(Icons.shopping_cart_rounded),
                                          onPressed: () {},
                                        ),
                                        Positioned(
                                            right: 8,
                                            top: 4,
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                      ],
                                    );
                                  } else if (cartState
                                      is UserCartOperationSucess) {
                                    return Stack(
                                      children: <Widget>[
                                        IconButton(
                                          icon:
                                              Icon(Icons.shopping_cart_rounded),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, "/cart_page");
                                          },
                                        ),
                                        Positioned(
                                            right: 8,
                                            top: 4,
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                cartState
                                                    .userCartModel.data.length
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                      ],
                                    );
                                  } else {
                                    return Container(
                                        child: Text(cartState.toString()));
                                  }
                                })

                            // Text(isLogin.toString()),
                          ],
                        );
                      } else {
                        return Container(
                          height: 2,
                          child: Text(""),
                        );
                      }
                    })
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              //new arrived products
              BlocBuilder<ProductBloc, ProductState>(
                bloc: BlocProvider.of<ProductBloc>(context),
                builder: (context, productState) {
                  if ((productState is ProductOperationSuccess &&
                      productState.productModel.data.length > 0)) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                          height: 230,
                          padding: EdgeInsets.all(10.0),
                          child: ListView.separated(
                            itemCount: productState.productModel.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  BlocProvider.of<ProductDetailsBloc>(context)
                                      .add(SetProductIds(productState
                                          .productModel
                                          .data[index]
                                          .products
                                          .productId));
                                },
                                child: Container(
                                  width: 180,
                                  padding: EdgeInsets.only(right: 0),
                                  child: Card(
                                    elevation: 4,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(35.0),
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
                                        // Positioned(
                                        //     left: 0,
                                        //     child: Container(
                                        //         child: productState.productModel
                                        //                 .data[index].favourite
                                        //             ? IconButton(
                                        //                 icon: Icon(Icons
                                        //                     .favorite_border),
                                        //                 onPressed: () {
                                        //                   checkLoginStatus(
                                        //                       context, index);
                                        //                 },
                                        //               )
                                        //             : IconButton(
                                        //                 icon: Icon(
                                        //                     Icons.favorite),
                                        //                 onPressed: () {
                                        //                   checkLoginStatus(
                                        //                       context, index);
                                        //                 },
                                        //               ))),
                                        Positioned(
                                            right: -5,
                                            top: -5,
                                            child: Container(
                                              child: IconButton(
                                                icon: Icon(Icons.shopping_cart,size: 22,),
                                                onPressed: () {
                                                  if (!isLogin) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "You have to login first",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIos: 1);
                                                  } else if (isLogin) {
                                                    showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (context) =>
                                                            CustomCartBottomSheet(
                                                                productState
                                                                    .productModel
                                                                    .data[index]
                                                                    .products
                                                                    .productId));
                                                  }
                                                },
                                              ),
                                            )),
                                        Positioned(
                                            bottom: 35,
                                            child: Container(
                                              width: 170,
                                              child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 0,left: 2,right: 2),
                                                  child: Text(
                                                    productState
                                                        .productModel
                                                        .data[index]
                                                        .products
                                                        .productName,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            )),
                                        Positioned(
                                            bottom: 6,
                                            child: Container(
                                              width: 180,
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
                                                        color: Colors.black,fontSize: 12),
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
                                      width: 200,
                                      margin: EdgeInsets.all(5),
                                      height: 240,
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
                    scheduleMicrotask(() => Navigator.of(context)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ProductPage()),
                            (Route<dynamic> route) => false));
                    return CircularProgressIndicator();
                  } else if (productState is SetProductItem) {
                    return Container(
                      child: Text("Loading"),
                    );
                  } else if (productState is setProductItemSuccess) {
                    scheduleMicrotask(() => Navigator.of(context).pushNamed(
                        "/product_details",
                        arguments: {"isLogin": isLogin}));
                    return CircularProgressIndicator();
                  } else if (productState is SingleProductLoaded) {
                    return Container(
                      child: Text(productState.toString()),
                    );
                  }
                  // else if (productState is SetProductId) {
                  //   scheduleMicrotask(() =>
                  //       Navigator.of(context).pushNamed("/product_details",arguments: {"isLogin" : isLogin}));
                  // }

                  //  else if (productState is getProductId) {
                  //   return Container(
                  //     child: Text(productState.toString()),
                  //   );
                  // }
                  // else if (productState is setSingleProductIdSucess) {
                  //   scheduleMicrotask(() => Navigator.of(context).pushNamed(
                  //       "/product_details",
                  //       arguments: {"isLogin": isLogin}));
                  //   return CircularProgressIndicator();
                  // }

                  else {
                    return Container(
                      child: Center(
                        child: Text(productState.toString()),
                      ),
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
                      physics: const NeverScrollableScrollPhysics(),
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
                          height: 230,
                          padding: EdgeInsets.all(10.0),
                          child: ListView.separated(
                            itemCount:
                                mostpopularState.productModel.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  BlocProvider.of<ProductDetailsBloc>(context)
                                      .add(SetProductIds(mostpopularState
                                          .productModel
                                          .data[index]
                                          .products
                                          .productId));
                                },
                                child: Container(
                                  width: 170,
                                  padding: EdgeInsets.only(right: 0),
                                  child: Card(
                                    elevation: 4,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(35.0),
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
                                        Positioned(
                                            right: -5,
                                            top: -5,
                                            child: Container(
                                              child: IconButton(
                                                icon: Icon(Icons.shopping_cart,size: 22,),
                                                onPressed: () {
                                                  if (!isLogin) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "You have to login first",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIos: 1);
                                                  } else if (isLogin) {
                                                    showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (context) =>
                                                            CustomCartBottomSheet(
                                                                mostpopularState
                                                                    .productModel
                                                                    .data[index]
                                                                    .products
                                                                    .productId));
                                                  }
                                                },
                                              ),
                                            )),
                                        Positioned(
                                            bottom: 35,
                                            child: Container(
                                              width: 170,
                                              child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 0,left: 2,right: 2),
                                                  child: Text(
                                                    mostpopularState
                                                        .productModel
                                                        .data[index]
                                                        .products
                                                        .productName,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            )),
                                        Positioned(
                                            bottom: 6,
                                            child: Container(
                                              width: 170,
                                              height: 25,
                                              child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    "\$" +
                                                        mostpopularState
                                                            .productModel
                                                            .data[index]
                                                            .products
                                                            .sellingPrice,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,fontSize: 12),
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
                                      width: 200,
                                      margin: EdgeInsets.all(5),
                                      height: 240,
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

              BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                  bloc: BlocProvider.of<ProductDetailsBloc>(context),
                  builder: (context, productdetailsState) {
                     if (productdetailsState is setSingleProductIdsSucess) {
                    scheduleMicrotask(() => Navigator.of(context).pushNamed(
                    "/product_details",
                    arguments: {"isLogin": isLogin}));
                    return CircularProgressIndicator();
                    }
                     else if(productdetailsState is ProductDetailsInitial){
                       return Container();
                     }
                     else if(productdetailsState is GetSingleProductIds){
                       return Container();
                     }
                     else{
                       return Container();
                     }

                  })
            ],
          ),
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
        // BlocProvider.of<ProductBloc>(context).add(LikeProduct(index));
        isLogin = true;
      } else {
        Navigator.pushNamed(context, '/login_page');
        isLogin = false;
      }
    } else {
      isLogin = false;
      Navigator.pushNamed(context, '/login_page');
    }
  }

  void checkLoginProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool("isLogin") != null) {
      if (preferences.getBool("isLogin")) {
        isLogin = true;
        BlocProvider.of<LoginBloc>(context).add(SetLoginStatus(isLogin));
        BlocProvider.of<ProductBloc>(context).add(FetchWithLoginProduct());
        BlocProvider.of<MostPopularBloc>(context)
            .add(FetchMostPopularProduct());
        BlocProvider.of<CartBloc>(context).add(FetchUserCart());
      } else {
        isLogin = false;
        BlocProvider.of<LoginBloc>(context).add(SetLoginStatus(isLogin));
        BlocProvider.of<MostPopularBloc>(context)
            .add(FetchMostPopularProduct());
        BlocProvider.of<ProductBloc>(context).add(FetchWithoutLoginProduct());
      }
    } else {
      isLogin = false;
      BlocProvider.of<LoginBloc>(context).add(SetLoginStatus(isLogin));
      BlocProvider.of<ProductBloc>(context).add(FetchWithoutLoginProduct());
      BlocProvider.of<MostPopularBloc>(context).add(FetchMostPopularProduct());
    }
  }
}
