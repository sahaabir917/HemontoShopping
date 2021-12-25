import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hemontoshoppin/SharedPreference/PreferenceHelper.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'package:hemontoshoppin/blocs/productbloc/product_bloc.dart';
import 'package:hemontoshoppin/blocs/productdetailsbloc/product_details_bloc.dart';
import 'package:hemontoshoppin/blocs/suggestedproducts/suggested_bloc.dart';
import 'package:hemontoshoppin/bottomsheet/CustomCartBottomSheet.dart';
import 'package:hemontoshoppin/util/ColorUtil.dart';
import 'package:hemontoshoppin/util/UserInfoUtils.dart';
import 'package:hemontoshoppin/util/checkingLoginutill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ColorUtil colorUtil = ColorUtil();
  UserInfoUtils userInfoUtils = UserInfoUtils();
  CheckingLoginUtil checkingLoginUtil = CheckingLoginUtil();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // checkLoginProduct();
        BlocProvider.of<SuggestedBloc>(context).add(FetchSugggestedProducts());
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
                                  BlocBuilder<CartBloc, CartState>(
                                      bloc: BlocProvider.of<CartBloc>(context),
                                      builder: (context, cartState) {
                                        if (cartState is CartInitial) {
                                          return Stack(
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons
                                                    .shopping_cart_rounded),
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
                                                icon: Icon(Icons
                                                    .shopping_cart_rounded),
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
                                                      cartState.userCartModel
                                                          .data.length
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          );
                                        } else if (cartState
                                            is fetchFailedCartProduct) {
                                          Navigator.pushNamed(
                                              context, "/login_page");
                                          return Container();
                                        }
                                      })
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
              body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                bloc: BlocProvider.of<ProductDetailsBloc>(context),
                builder: (context, productdetailsState) {
                  if (productdetailsState is ProductDetailsInitial) {
                    return Container(
                      child: Text(productdetailsState.toString()),
                    );
                  } else if (productdetailsState is GetSingleProductIds) {
                    BlocProvider.of<ProductDetailsBloc>(context).add(
                        LoadingSingleProducts(
                            productdetailsState.productId,
                            productdetailsState.productCatId,
                            productdetailsState.productSubCatId));
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (productdetailsState is ProductDetailsLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (productdetailsState is LoadedSingleProducts) {
                    return Padding(
                      padding: EdgeInsets.all(0),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 4,
                              height: MediaQuery.of(context).size.height * .3,
                              child: Image.network(
                                "https://ecotech.xixotech.net/public/" +
                                    productdetailsState
                                        .productModel.data[0].products.imageOne,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -30,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.zero,
                                    top: Radius.circular(40)),
                              ),
                              child: SingleChildScrollView(
                                physics: ScrollPhysics(),
                                //suggested and related products
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          productdetailsState.productModel
                                              .data[0].products.productName,
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
                                                    productdetailsState
                                                            .productModel
                                                            .data[0]
                                                            .favourite
                                                        ? IconButton(
                                                            icon: Icon(Icons
                                                                .favorite_border),
                                                            onPressed: () {
                                                              BlocProvider.of<
                                                                          ProductBloc>(
                                                                      context)
                                                                  .add(LikeProduct(productdetailsState
                                                                      .productModel
                                                                      .data[0]
                                                                      .products
                                                                      .productId));
                                                              productdetailsState
                                                                  .productModel
                                                                  .data[0]
                                                                  .favourite = false;
                                                              setState(() {});
                                                            })
                                                        : IconButton(
                                                            icon: Icon(
                                                                Icons.favorite),
                                                            onPressed: () {
                                                              BlocProvider.of<
                                                                          ProductBloc>(
                                                                      context)
                                                                  .add(LikeProduct(productdetailsState
                                                                      .productModel
                                                                      .data[0]
                                                                      .products
                                                                      .productId));
                                                              // BlocProvider.of<ProductBloc>(context).add(getProductId());
                                                              productdetailsState
                                                                  .productModel
                                                                  .data[0]
                                                                  .favourite = true;
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Card(
                                            color: Colors.white70,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    "Product Code : ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    productdetailsState
                                                        .productModel
                                                        .data[0]
                                                        .products
                                                        .productCode,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons
                                                        .arrow_forward_ios_outlined),
                                                    iconSize: 20,
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Brand : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          productdetailsState.productModel
                                              .data[0].products.brandName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            backgroundColor: Colors.black,
                                          ),
                                        ),
                                        Image.network(
                                          "https://ecotech.xixotech.net/public/" +
                                              productdetailsState.productModel
                                                  .data[0].products.brandLogo,
                                          height: 70,
                                          width: 70,
                                        ),
                                        //brandlogo isnot valid sometimes
                                        // Container(
                                        //   height: 100,
                                        //   child: Image.network(
                                        //       "https://ecotech.xixotech.net/public/" +
                                        //           productdetailsState
                                        //               .productModel
                                        //               .data[0]
                                        //               .products
                                        //               .brandLogo),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Product Price : " +
                                          productdetailsState.productModel
                                              .data[0].products.sellingPrice,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 30,
                                            right: 30,
                                            top: 10,
                                            bottom: 10),
                                        child: Html(
                                          data: productdetailsState.productModel
                                              .data[0].products.productDetails,
                                          defaultTextStyle:
                                              TextStyle(fontSize: 14),
                                          onLinkTap: (link) {
                                            launch(link);
                                          },
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "More Pictures :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 80,
                                          child: Image.network(
                                              "https://ecotech.xixotech.net/public/" +
                                                  productdetailsState
                                                      .productModel
                                                      .data[0]
                                                      .products
                                                      .imageTwo),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 80,
                                          child: Image.network(
                                              "https://ecotech.xixotech.net/public/" +
                                                  productdetailsState
                                                      .productModel
                                                      .data[0]
                                                      .products
                                                      .imageThree),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "related products",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                    GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 1.6,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0,
                                        ),
                                        itemCount: productdetailsState
                                            .relatedProducts.data.length,
                                        itemBuilder: (ctx, i) => GridTile(
                                              child: InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      bottom: 20),
                                                  child: Container(
                                                    color: colorUtil
                                                        .getColorofDeals(i),
                                                    // child: Align(
                                                    //   alignment:
                                                    //       Alignment.center,
                                                    //   child: Text(
                                                    //     productdetailsState
                                                    //         .relatedProducts
                                                    //         .data[i]
                                                    //         .products
                                                    //         .productName,
                                                    //     textAlign:
                                                    //         TextAlign.center,
                                                    //     style: TextStyle(
                                                    //         color: Colors.black,
                                                    //         fontWeight:
                                                    //             FontWeight
                                                    //                 .normal),
                                                    //   ),
                                                    // ),

                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          color: Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4,
                                                                    bottom: 4),
                                                            child: Image.network(
                                                                "https://ecotech.xixotech.net/public/" +
                                                                    productdetailsState
                                                                        .relatedProducts
                                                                        .data[i]
                                                                        .products
                                                                        .imageOne,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .08,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            productdetailsState
                                                                .relatedProducts
                                                                .data[i]
                                                                .products
                                                                .productName,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                    SizedBox(
                                      height: size.height * .15,
                                    ),

                                    //add the suggested products
                                    // Text("Suggested products"),
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
                    return Container();
                  }
                },
              )),
          bottomSheet: Container(
              height: 50,
              child: BlocBuilder<LoginBloc, LoginState>(
                bloc: BlocProvider.of<LoginBloc>(context),
                builder: (context, loginState) {
                  if (loginState is AlreadyLogin ||
                      loginState is NoLogin ||
                      loginState is LoginInitial) {
                    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                        bloc: BlocProvider.of<ProductDetailsBloc>(context),
                        builder: (context, productState) {
                          if (productState is LoadedSingleProducts) {
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
                                                BlocBuilder<LoginBloc,
                                                        LoginState>(
                                                    bloc: BlocProvider.of<
                                                        LoginBloc>(context),
                                                    builder:
                                                        (context, loginState) {
                                                      if (loginState
                                                          is NoLogin) {
                                                        return Container();
                                                      } else {
                                                        return productState
                                                                .productModel
                                                                .data[0]
                                                                .favourite
                                                            ? IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .favorite_border,
                                                                  size: 20,
                                                                ),
                                                                onPressed: () {
                                                                  BlocProvider.of<
                                                                              ProductBloc>(
                                                                          context)
                                                                      .add(LikeProduct(productState
                                                                          .productModel
                                                                          .data[
                                                                              0]
                                                                          .products
                                                                          .productId));
                                                                  productState
                                                                      .productModel
                                                                      .data[0]
                                                                      .favourite = false;
                                                                  setState(
                                                                      () {});
                                                                },
                                                              )
                                                            : IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  size: 20,
                                                                ),
                                                                onPressed: () {
                                                                  BlocProvider.of<
                                                                              ProductBloc>(
                                                                          context)
                                                                      .add(LikeProduct(productState
                                                                          .productModel
                                                                          .data[
                                                                              0]
                                                                          .products
                                                                          .productId));
                                                                  // BlocProvider.of<ProductBloc>(context).add(getProductId());
                                                                  productState
                                                                      .productModel
                                                                      .data[0]
                                                                      .favourite = true;
                                                                  setState(
                                                                      () {});
                                                                },
                                                              );
                                                      }
                                                    }),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text("Add to favourite",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (loginState is AlreadyLogin) {
                                          BlocProvider.of<ProductBloc>(context)
                                              .add(LikeProduct(productState
                                                  .productModel
                                                  .data[0]
                                                  .products
                                                  .productId));
                                          if (productState.productModel.data[0]
                                                  .favourite ==
                                              true) {
                                            productState.productModel.data[0]
                                                .favourite = false;
                                            setState(() {});
                                          } else if (productState.productModel
                                                  .data[0].favourite ==
                                              false) {
                                            productState.productModel.data[0]
                                                .favourite = true;
                                            setState(() {});
                                          }
                                        } else if (loginState is NoLogin) {
                                          Navigator.pushNamed(
                                              context, "/login_page");
                                        }
                                      },
                                    ),
                                  ), //favourite btn
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
                                                Icon(Icons
                                                    .shopping_cart_rounded),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text("Add to cart",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (loginState is AlreadyLogin) {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) =>
                                                  CustomCartBottomSheet(
                                                      productState
                                                          .productModel
                                                          .data[0]
                                                          .products
                                                          .productId));
                                        } else if (loginState is NoLogin) {
                                          Navigator.pushNamed(
                                              context, "/login_page");
                                        }
                                      },
                                    ),
                                  ) //add to cart btn
                                ],
                              ),
                            );
                          } else if (productState is ProductDetailsInitial) {
                            return Text("");
                          } else {
                            return Container(
                              child: Text(""),
                            );
                          }
                        });
                  }
                },
              ))),
    );
  }

  @override
  void initState() {
    BlocProvider.of<ProductDetailsBloc>(context).add(getProductIds());
    checkLogin();
  }

  void checkLogin() async {
    isLogin = await checkingLoginUtil.isLogin();
    print("isLogin: $isLogin");
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
