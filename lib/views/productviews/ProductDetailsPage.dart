import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hemontoshoppin/SharedPreference/PreferenceHelper.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
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
  bool isLogin = true;
  static PreferenceHelper preferenceHelper = new PreferenceHelper();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return WillPopScope(
      onWillPop: () async {
        checkLoginProduct();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                  // BlocProvider.of<ProductBloc>(context).add(getProductItem());
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.zero,
                                    top: Radius.circular(40)),
                                color: Colors.white),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 150,
                                      height: 7,
                                      decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    productState.products.productName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(30),
                                      child: Html(
                                        data: productState
                                            .products.productDetails,
                                      )),
                                  Text(productState.products.sellingPrice),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            height: size.height * .6,
                          ),
                        )
                      ],
                    ),
                  );
                } else if (productState is GetSingleProductId) {
                  BlocProvider.of<ProductBloc>(context)
                      .add(LoadingSingleProduct(productState.productId));
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (productState is LoadedSingleProduct) {
                  return Padding(
                    padding: EdgeInsets.all(2),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Image.network(
                              "https://ecotech.xixotech.net/public/" +
                                  productState
                                      .productModel.data[0].products.imageOne,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.zero,
                                    top: Radius.circular(40)),
                                color: Colors.white),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 150,
                                      height: 7,
                                      decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        productState.productModel.data[0]
                                            .products.productName,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      BlocBuilder<LoginBloc, LoginState>(
                                          bloc: BlocProvider.of<LoginBloc>(
                                              context),
                                          builder: (context, loginState) {
                                            if (loginState is NoLogin) {
                                              return Container(
                                                height: 2,
                                                child: Text(""),
                                              );
                                            } else if (loginState
                                            is AlreadyLogin) {
                                              return Row(
                                                children: <Widget>[
                                                  productState.productModel
                                                      .data[0].favourite
                                                      ? IconButton(
                                                      icon: Icon(Icons
                                                          .favorite_border),
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                            ProductBloc>(
                                                            context)
                                                            .add(LikeProduct(
                                                            productState
                                                                .productModel
                                                                .data[0]
                                                                .products
                                                                .productId));
                                                        productState
                                                            .productModel
                                                            .data[0]
                                                            .favourite =
                                                        false;
                                                        setState(() {});
                                                      })
                                                      : IconButton(
                                                      icon: Icon(
                                                          Icons.favorite),
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                            ProductBloc>(
                                                            context)
                                                            .add(LikeProduct(
                                                            productState
                                                                .productModel
                                                                .data[0]
                                                                .products
                                                                .productId));
                                                        // BlocProvider.of<ProductBloc>(context).add(getProductId());
                                                        productState
                                                            .productModel
                                                            .data[0]
                                                            .favourite =
                                                        true;
                                                        setState(() {});
                                                      }),
                                                  // Text(isLogin.toString()),
                                                ],
                                              );
                                            } else {
                                              Container(
                                                height: 2,
                                                child: Text(""),
                                              );
                                            }
                                          }),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(30),
                                      child: Html(
                                        data: productState.productModel.data[0]
                                            .products.productDetails,
                                      )),
                                  Text(productState.productModel.data[0]
                                      .products.sellingPrice),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            height: size.height * .6,
                          ),
                        )
                      ],
                    ),
                  );
                }
                // else if(productState is ProductOperationSuccess){
                //
                // }
                else {
                  // Navigator.pop(context);
                  return Container(
                    child: Text(productState.toString()),
                  );
                }
              },
            )),
        bottomSheet:
        Container(
          height: 50,
          child:
          BlocBuilder<LoginBloc,LoginState>(
            bloc: BlocProvider.of<LoginBloc>(context),
            builder: (context,loginState){
              if(loginState is AlreadyLogin || loginState is NoLogin || loginState is LoginInitial ){
                return BlocBuilder<ProductBloc, ProductState>(
                    bloc: BlocProvider.of<ProductBloc>(context),
                    builder: (context, productState) {
                      if (productState is LoadedSingleProduct) {
                        return Container(
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    color: Colors.grey[800],
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            BlocBuilder<LoginBloc, LoginState>(
                                                bloc: BlocProvider.of<LoginBloc>(
                                                    context),
                                                builder: (context, loginState) {
                                                  if (loginState is NoLogin) {
                                                    return Container();
                                                  }
                                                  else {
                                                    return productState.productModel
                                                        .data[0].favourite
                                                        ? IconButton(
                                                      icon: Icon(
                                                        Icons.favorite_border,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                            ProductBloc>(
                                                            context)
                                                            .add(LikeProduct(
                                                            productState
                                                                .productModel
                                                                .data[0]
                                                                .products
                                                                .productId));
                                                        productState
                                                            .productModel
                                                            .data[0]
                                                            .favourite = false;
                                                        setState(() {});
                                                      },
                                                    )
                                                        : IconButton(
                                                      icon: Icon(
                                                        Icons.favorite,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                            ProductBloc>(
                                                            context)
                                                            .add(LikeProduct(
                                                            productState
                                                                .productModel
                                                                .data[0]
                                                                .products
                                                                .productId));
                                                        // BlocProvider.of<ProductBloc>(context).add(getProductId());
                                                        productState
                                                            .productModel
                                                            .data[0]
                                                            .favourite = true;
                                                        setState(() {});
                                                      },
                                                    );
                                                  }
                                                }),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Add to favourite",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if(loginState is AlreadyLogin){
                                      BlocProvider.of<ProductBloc>(context).add(
                                          LikeProduct(productState.productModel
                                              .data[0].products.productId));
                                      if (productState
                                          .productModel.data[0].favourite ==
                                          true) {
                                        productState.productModel.data[0].favourite =
                                        false;
                                        setState(() {});
                                      } else if (productState
                                          .productModel.data[0].favourite ==
                                          false) {
                                        productState.productModel.data[0].favourite =
                                        true;
                                        setState(() {});
                                      }
                                    }
                                    else if(loginState is NoLogin){
                                      Navigator.pushNamed(context, "/login_page");
                                    }
                                  },
                                ),
                              ),   //favourite btn
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    color: Colors.red[400],
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(Icons.shopping_cart_rounded),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text("Add to cart",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )    //add to cart btn
                            ],
                          ),
                        );
                      } else if (productState is ProductInitial) {
                        return Text("");
                      } else {
                        return Container(
                          child: Text(""),
                        );
                      }
                    });
              }
            },
          )

        )


        // BlocBuilder<LoginBloc, LoginState>(
        //     bloc: BlocProvider.of<LoginBloc>(
        //         context),
        //     builder: (context, loginState) {
        //       if(loginState is AlreadyLogin){
        //        return Container(
        //           height: 50,
        //           child: BlocBuilder<ProductBloc, ProductState>(
        //               bloc: BlocProvider.of<ProductBloc>(context),
        //               builder: (context, productState) {
        //                 if (productState is LoadedSingleProduct) {
        //                   return Container(
        //                     height: 50,
        //                     child: Row(
        //                       children: <Widget>[
        //                         Expanded(
        //                           child: InkWell(
        //                             child: Container(
        //                               color: Colors.grey[800],
        //                               child: Center(
        //                                 child: Padding(
        //                                   padding: EdgeInsets.all(8.0),
        //                                   child: Row(
        //                                     children: [
        //                                       BlocBuilder<LoginBloc, LoginState>(
        //                                           bloc: BlocProvider.of<LoginBloc>(
        //                                               context),
        //                                           builder: (context, loginState) {
        //                                             if (loginState is NoLogin) {
        //                                               return Container();
        //                                             }
        //                                             else {
        //                                               return productState.productModel
        //                                                   .data[0].favourite
        //                                                   ? IconButton(
        //                                                 icon: Icon(
        //                                                   Icons.favorite_border,
        //                                                   size: 20,
        //                                                 ),
        //                                                 onPressed: () {
        //                                                   BlocProvider.of<
        //                                                       ProductBloc>(
        //                                                       context)
        //                                                       .add(LikeProduct(
        //                                                       productState
        //                                                           .productModel
        //                                                           .data[0]
        //                                                           .products
        //                                                           .productId));
        //                                                   productState
        //                                                       .productModel
        //                                                       .data[0]
        //                                                       .favourite = false;
        //                                                   setState(() {});
        //                                                 },
        //                                               )
        //                                                   : IconButton(
        //                                                 icon: Icon(
        //                                                   Icons.favorite,
        //                                                   size: 20,
        //                                                 ),
        //                                                 onPressed: () {
        //                                                   BlocProvider.of<
        //                                                       ProductBloc>(
        //                                                       context)
        //                                                       .add(LikeProduct(
        //                                                       productState
        //                                                           .productModel
        //                                                           .data[0]
        //                                                           .products
        //                                                           .productId));
        //                                                   // BlocProvider.of<ProductBloc>(context).add(getProductId());
        //                                                   productState
        //                                                       .productModel
        //                                                       .data[0]
        //                                                       .favourite = true;
        //                                                   setState(() {});
        //                                                 },
        //                                               );
        //                                             }
        //                                           }),
        //                                       SizedBox(
        //                                         width: 10,
        //                                       ),
        //                                       Text("Add to favourite",
        //                                           style: TextStyle(
        //                                               color: Colors.white,
        //                                               fontWeight: FontWeight.bold)),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                             onTap: () {
        //                               BlocProvider.of<ProductBloc>(context).add(
        //                                   LikeProduct(productState.productModel
        //                                       .data[0].products.productId));
        //                               if (productState
        //                                   .productModel.data[0].favourite ==
        //                                   true) {
        //                                 productState.productModel.data[0].favourite =
        //                                 false;
        //                                 setState(() {});
        //                               } else if (productState
        //                                   .productModel.data[0].favourite ==
        //                                   false) {
        //                                 productState.productModel.data[0].favourite =
        //                                 true;
        //                                 setState(() {});
        //                               }
        //                             },
        //                           ),
        //                         ),
        //                         Expanded(
        //                           child: InkWell(
        //                             child: Container(
        //                               color: Colors.red[400],
        //                               child: Center(
        //                                 child: Padding(
        //                                   padding: EdgeInsets.all(8.0),
        //                                   child: Row(
        //                                     children: [
        //                                       SizedBox(
        //                                         width: 10,
        //                                       ),
        //                                       Icon(Icons.shopping_cart_rounded),
        //                                       SizedBox(
        //                                         width: 20,
        //                                       ),
        //                                       Text("Add to cart",
        //                                           style: TextStyle(
        //                                               color: Colors.white,
        //                                               fontWeight: FontWeight.bold)),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                   );
        //                 } else if (productState is ProductInitial) {
        //                   return Text("");
        //                 } else {
        //                   return Container(
        //                     child: Text(""),
        //                   );
        //                 }
        //               }),
        //         );
        //       }
        //       else if(loginState is NoLogin){
        //         return Container(
        //           child: Text(""),
        //         );
        //       }
        //     })

      ),
    );
  }

  @override
  void initState() {
    // BlocProvider.of<ProductBloc>(context).add(getProductItem());
    BlocProvider.of<ProductBloc>(context).add(getProductId());
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
