import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hemontoshoppin/SharedPreference/PreferenceHelper.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/dealdetails/deal_details_bloc.dart';
import 'package:hemontoshoppin/blocs/dealsbloc/deal_bloc.dart';
import 'package:hemontoshoppin/blocs/discountedproduct/discounted_product_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'package:hemontoshoppin/blocs/packageproduct/package_product_bloc.dart';
import 'package:hemontoshoppin/blocs/productbloc/product_bloc.dart';
import 'package:hemontoshoppin/blocs/productdetailsbloc/product_details_bloc.dart';
import 'package:hemontoshoppin/blocs/suggestedproducts/suggested_bloc.dart';
import 'package:hemontoshoppin/bottomsheet/CustomCartBottomSheet.dart';
import 'package:hemontoshoppin/util/ColorUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ColorUtil colorUtil = ColorUtil();
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

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
                height: 0,
              ),
              //new arrived products

              //most popular products
              BlocBuilder<MostPopularBloc, MostPopularState>(
                bloc: BlocProvider.of<MostPopularBloc>(context),
                // ignore: missing_return
                builder: (context, mostpopularState) {
                  if ((mostpopularState
                  is MostPopularProductOperationSuccess)) {
                    if (mostpopularState.productModel.data.length > 0) {
                      return ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          //deals products

                          BlocBuilder<DealBloc, DealsState>(
                            bloc: BlocProvider.of<DealBloc>(context),
                            builder: (context, dealState) {
                              if (dealState is DealsInitial) {
                                return Container();
                              } else if (dealState is LoadedDeals) {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                            autoPlay: true,
                                            reverse: true,
                                            autoPlayInterval:
                                            Duration(seconds: 4),
                                            viewportFraction: 1.0,
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height *
                                                .21,
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                _current = index;
                                              });
                                            }),
                                        items: dealState.dealModel.deals
                                            .map((item) {
                                          var index = dealState.dealModel.deals
                                              .indexOf(item);
                                          return Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Container(
                                              child: InkWell(
                                                onTap: () {
                                                  BlocProvider.of<
                                                      DealDetailsBloc>(context)
                                                      .add(setDealId(
                                                      item.id, item.dealName));
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  color: colorUtil
                                                      .getColorofDeals(index),
                                                  // shape: BeveledRectangleBorder(
                                                  //   borderRadius: BorderRadius.circular(10.0),
                                                  // ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(20),
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        color: Colors.white,
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width,
                                                        child: Image.network(
                                                          "https://ecotech.xixotech.net/public/" +
                                                              item.dealPicture,
                                                          height:
                                                          MediaQuery
                                                              .of(context)
                                                              .size
                                                              .height *
                                                              .1,
                                                          width:
                                                          MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width *
                                                              .8,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3,),
                                                      Text(
                                                        item.dealName,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: 20),
                                                        child: Html(
                                                          data: item
                                                              .dealDescription,
                                                          defaultTextStyle:
                                                          TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 10),
                                                          onLinkTap: (link) {
                                                            launch(link);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children:
                                      map<Widget>(dealState.dealModel.deals,
                                              (index, url) {
                                            return Container(
                                              width: 10.0,
                                              height: 10.0,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 2.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _current == index
                                                    ? Colors.lightGreen
                                                    : Colors.tealAccent,
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                          SizedBox(height: 15),
                          //most popular blog
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Most Popular",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            height: MediaQuery.of(context).size.height*.29,
                            padding: EdgeInsets.all(10.0),
                            child: ListView.separated(
                              itemCount:
                              mostpopularState.productModel.data.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    BlocProvider.of<ProductDetailsBloc>(context)
                                        .add(SetProductIds(
                                        mostpopularState.productModel
                                            .data[index].products.productId,
                                        mostpopularState
                                            .productModel
                                            .data[index]
                                            .products
                                            .categoryId,
                                        mostpopularState
                                            .productModel
                                            .data[index]
                                            .products
                                            .subcategoryId));
                                  },
                                  child: Container(
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * .5,
                                    padding:
                                    EdgeInsets.only(right: 10, left: 10),
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
                                                  icon: Icon(
                                                    Icons.shopping_cart,
                                                    size: 22,
                                                  ),
                                                  onPressed: () {
                                                    if (!isLogin) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                          "You have to login first",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIos: 1);
                                                    } else if (isLogin) {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                          true,
                                                          backgroundColor:
                                                          Colors
                                                              .transparent,
                                                          context: context,
                                                          builder: (context) =>
                                                              CustomCartBottomSheet(
                                                                  mostpopularState
                                                                      .productModel
                                                                      .data[
                                                                  index]
                                                                      .products
                                                                      .productId));
                                                    }
                                                  },
                                                ),
                                              )),
                                          Positioned(
                                              bottom: 35,
                                              child: Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width *
                                                    .4,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0,
                                                        left: 2,
                                                        right: 2),
                                                    child: Text(
                                                      mostpopularState
                                                          .productModel
                                                          .data[index]
                                                          .products
                                                          .productName,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textAlign:
                                                      TextAlign.center,
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
                                                width: MediaQuery.of(context).size.width*.42,
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
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    )),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return index == 0
                                    ? SizedBox(height: 0)
                                    : index % 6 == 0
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
                                          child:
                                          CircularProgressIndicator()),
                                      error: Text('failed to load'),
                                    ))
                                    : Container();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //package products
                          BlocBuilder<PackageProductBloc, PackageProductState>(
                            bloc: BlocProvider.of<PackageProductBloc>(context),
                            builder: (context, packageProductState) {
                              if ((packageProductState
                              is PackageProductLoaded &&
                                  packageProductState.productModel.data.length >
                                      0)) {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 10),
                                            child: Text(
                                              "Package Products",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),

                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height*.29,
                                      padding: EdgeInsets.all(10.0),
                                      child: ListView.separated(
                                        itemCount: packageProductState
                                            .productModel.data.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              BlocProvider.of<
                                                  ProductDetailsBloc>(
                                                  context)
                                                  .add(SetProductIds(
                                                  packageProductState
                                                      .productModel
                                                      .data[index]
                                                      .products
                                                      .productId,
                                                  packageProductState
                                                      .productModel
                                                      .data[index]
                                                      .products
                                                      .categoryId,
                                                  packageProductState
                                                      .productModel
                                                      .data[index]
                                                      .products
                                                      .subcategoryId));
                                            },
                                            child: Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width *
                                                  .5,
                                              padding: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Card(
                                                elevation: 4,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          35.0),
                                                      child: Container(
                                                        child: Image.network(
                                                            "https://ecotech.xixotech.net/public/" +
                                                                packageProductState
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
                                                            icon: Icon(
                                                              Icons
                                                                  .shopping_cart,
                                                              size: 22,
                                                            ),
                                                            onPressed: () {
                                                              if (!isLogin) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                    msg:
                                                                    "You have to login first",
                                                                    toastLength:
                                                                    Toast
                                                                        .LENGTH_SHORT,
                                                                    gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                    timeInSecForIos:
                                                                    1);
                                                              } else
                                                              if (isLogin) {
                                                                showModalBottomSheet(
                                                                    isScrollControlled:
                                                                    true,
                                                                    backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                    context:
                                                                    context,
                                                                    builder: (
                                                                        context) =>
                                                                        CustomCartBottomSheet(
                                                                            packageProductState
                                                                                .productModel
                                                                                .data[
                                                                            index]
                                                                                .products
                                                                                .productId));
                                                              }
                                                            },
                                                          ),
                                                        )),
                                                    Positioned(
                                                        bottom: 35,
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width*.42,
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top: 0,
                                                                  left: 2,
                                                                  right: 2),
                                                              child: Text(
                                                                packageProductState
                                                                    .productModel
                                                                    .data[index]
                                                                    .products
                                                                    .productName,
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                maxLines: 2,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                        )),
                                                    Positioned(
                                                        bottom: 6,
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width*.42,
                                                          height: 25,
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(top: 5),
                                                              child: Text(
                                                                "\$" +
                                                                    packageProductState
                                                                        .productModel
                                                                        .data[
                                                                    index]
                                                                        .products
                                                                        .sellingPrice,
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                    12),
                                                              )),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return index == 0 ? SizedBox(
                                            height: 0,) : index % 8 == 0
                                              ? Container(
                                              width: 200,
                                              margin: EdgeInsets.all(5),
                                              height: 240,
                                              color: Colors.green,
                                              child: NativeAdmob(
                                                adUnitID:
                                                NativeAd.testAdUnitId,
                                                controller:
                                                _nativeAdController,
                                                type: NativeAdmobType.full,
                                                loading: Center(
                                                    child:
                                                    CircularProgressIndicator()),
                                                error:
                                                Text('failed to load'),
                                              ))
                                              : Container();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else if (packageProductState
                              is PackageProductInitail) {
                                return Container(
                                  child: Text(""),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //discounted Products
                          BlocBuilder<DiscountedProductBloc,
                              DiscountedProductState>(
                            bloc:
                            BlocProvider.of<DiscountedProductBloc>(context),
                            builder: (context, discountedProductState) {
                              if ((discountedProductState
                              is DiscountedProductLoaded &&
                                  discountedProductState
                                      .productModel.data.length >
                                      0)) {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Discounted Products",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      child: Container(
                                        height: 200,
                                        child: ListView.separated(
                                          itemCount: discountedProductState
                                              .productModel.data.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                BlocProvider.of<
                                                    ProductDetailsBloc>(
                                                    context)
                                                    .add(SetProductIds(
                                                    discountedProductState
                                                        .productModel
                                                        .data[index]
                                                        .products
                                                        .productId,
                                                    discountedProductState
                                                        .productModel
                                                        .data[index]
                                                        .products
                                                        .categoryId,
                                                    discountedProductState
                                                        .productModel
                                                        .data[index]
                                                        .products
                                                        .subcategoryId));
                                              },
                                              child: Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width *
                                                    .5,
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Card(
                                                  elevation: 4,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(35.0),
                                                        child: Container(
                                                          child: Image.network(
                                                              "https://ecotech.xixotech.net/public/" +
                                                                  discountedProductState
                                                                      .productModel
                                                                      .data[
                                                                  index]
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
                                                              icon: Icon(
                                                                Icons
                                                                    .shopping_cart,
                                                                size: 22,
                                                              ),
                                                              onPressed: () {
                                                                if (!isLogin) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                      msg:
                                                                      "You have to login first",
                                                                      toastLength:
                                                                      Toast
                                                                          .LENGTH_SHORT,
                                                                      gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                      timeInSecForIos:
                                                                      1);
                                                                } else
                                                                if (isLogin) {
                                                                  showModalBottomSheet(
                                                                      isScrollControlled:
                                                                      true,
                                                                      backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                      context:
                                                                      context,
                                                                      builder: (
                                                                          context) =>
                                                                          CustomCartBottomSheet(
                                                                              discountedProductState
                                                                                  .productModel
                                                                                  .data[
                                                                              index]
                                                                                  .products
                                                                                  .productId));
                                                                }
                                                              },
                                                            ),
                                                          )),
                                                      Positioned(
                                                          bottom: 35,
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width*.42,
                                                            child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    top: 0,
                                                                    left: 2,
                                                                    right:
                                                                    2),
                                                                child: Text(
                                                                  discountedProductState
                                                                      .productModel
                                                                      .data[
                                                                  index]
                                                                      .products
                                                                      .productName,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                )),
                                                          )),
                                                      Positioned(
                                                          bottom: 6,
                                                          child: Container(
                                                            width: 180,
                                                            height: 25,
                                                            child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    top: 5),
                                                                child: Text(
                                                                  "\$" +
                                                                      discountedProductState
                                                                          .productModel
                                                                          .data[
                                                                      index]
                                                                          .products
                                                                          .sellingPrice,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      12),
                                                                )),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return index == 0 ? SizedBox(
                                              height: 0,) : index % 8 == 0
                                                ? Container(
                                                width: 200,
                                                margin: EdgeInsets.all(5),
                                                height: 240,
                                                color: Colors.green,
                                                child: NativeAdmob(
                                                  adUnitID:
                                                  NativeAd.testAdUnitId,
                                                  controller:
                                                  _nativeAdController,
                                                  type:
                                                  NativeAdmobType.full,
                                                  loading: Center(
                                                      child:
                                                      CircularProgressIndicator()),
                                                  error: Text(
                                                      'failed to load'),
                                                ))
                                                : Container();
                                          },
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 15),
                                    ),
                                  ],
                                );
                              } else if (discountedProductState
                              is DiscountedProductInitial) {
                                return Container(
                                  child: Text(""),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DefaultTabController(
                            length: 3,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  child: TabBar(
                                    indicatorColor: Colors.grey,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.grey,
                                    unselectedLabelStyle:
                                    TextStyle(fontSize: 10.0),
                                    tabs: [
                                      Tab(text: "All Products"),
                                      Tab(text: "All Brand"),
                                      Tab(text: "Suggested"),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * .67,
                                    child: TabBarView(children: [
                                      BlocBuilder<ProductBloc, ProductState>(
                                        bloc: BlocProvider.of<ProductBloc>(
                                            context),
                                        builder: (context, productState) {
                                          if ((productState
                                          is ProductOperationSuccess &&
                                              productState.productModel.data
                                                  .length >
                                                  0)) {
                                            return ListView(
                                              shrinkWrap: true,
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              children: [
                                                Container(
                                                  padding:
                                                  EdgeInsets.only(left: 15),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(left: 20,
                                                            top: 15),
                                                        child: Text(
                                                          "New Arrived",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height *
                                                      .65,
                                                  padding: EdgeInsets.all(30.0),
                                                  child: ListView.separated(
                                                    itemCount: productState
                                                        .productModel
                                                        .data
                                                        .length,
                                                    scrollDirection:
                                                    Axis.vertical,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          BlocProvider.of<
                                                              ProductDetailsBloc>(
                                                              context)
                                                              .add(
                                                              SetProductIds(
                                                                  productState
                                                                      .productModel
                                                                      .data[
                                                                  index]
                                                                      .products
                                                                      .productId,
                                                                  productState
                                                                      .productModel
                                                                      .data[
                                                                  index]
                                                                      .products
                                                                      .categoryId,
                                                                  productState
                                                                      .productModel
                                                                      .data[
                                                                  index]
                                                                      .products
                                                                      .subcategoryId));
                                                        },
                                                        child: Container(
                                                          width: 180,
                                                          height: 100,
                                                          padding:
                                                          EdgeInsets.only(
                                                              right: 0),
                                                          child: Card(
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10.0),
                                                            ),
                                                            elevation: 4,
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                                  child:
                                                                  Container(
                                                                    child: Image
                                                                        .network(
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
                                                                    child:
                                                                    Container(
                                                                      child:
                                                                      IconButton(
                                                                        icon:
                                                                        Icon(
                                                                          Icons
                                                                              .shopping_cart,
                                                                          size:
                                                                          22,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          if (!isLogin) {
                                                                            Fluttertoast
                                                                                .showToast(
                                                                                msg: "You have to login first",
                                                                                toastLength: Toast
                                                                                    .LENGTH_SHORT,
                                                                                gravity: ToastGravity
                                                                                    .CENTER,
                                                                                timeInSecForIos: 1);
                                                                          } else
                                                                          if (isLogin) {
                                                                            showModalBottomSheet(
                                                                                isScrollControlled: true,
                                                                                backgroundColor: Colors
                                                                                    .transparent,
                                                                                context: context,
                                                                                builder: (
                                                                                    context) =>
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
                                                                    left: 90,
                                                                    top: 20,
                                                                    child:
                                                                    Container(
                                                                      width:
                                                                      200,
                                                                      child: Padding(
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                              top: 0,
                                                                              left: 2,
                                                                              right: 2),
                                                                          child: Text(
                                                                            productState
                                                                                .productModel
                                                                                .data[index]
                                                                                .products
                                                                                .productName,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                            maxLines:
                                                                            1,
                                                                            overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .black,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight
                                                                                    .bold),
                                                                          )),
                                                                    )),
                                                                Positioned(
                                                                    top: 40,
                                                                    left: 140,
                                                                    child:
                                                                    Container(
                                                                      width: 90,
                                                                      height:
                                                                      25,
                                                                      child: Padding(
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                              top: 5),
                                                                          child: Text(
                                                                            "\$" +
                                                                                productState
                                                                                    .productModel
                                                                                    .data[index]
                                                                                    .products
                                                                                    .sellingPrice,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                            style:
                                                                            TextStyle(
                                                                                color: Colors
                                                                                    .black,
                                                                                fontSize: 15),
                                                                          )),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return index == 0
                                                          ? SizedBox(height: 0,)
                                                          : index % 4 == 0
                                                          ? Container(
                                                          width: 200,
                                                          margin: EdgeInsets
                                                              .all(5),
                                                          height: 180,
                                                          color:
                                                          Colors.green,
                                                          child:
                                                          NativeAdmob(
                                                            adUnitID: NativeAd
                                                                .testAdUnitId,
                                                            controller:
                                                            _nativeAdController,
                                                            type:
                                                            NativeAdmobType
                                                                .full,
                                                            loading: Center(
                                                                child:
                                                                CircularProgressIndicator()),
                                                            error: Text(
                                                                'failed to load'),
                                                          ))
                                                          : Container();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (productState
                                          is LoadedMostPopularProduct) {
                                            return Container(
                                              child: Text("sad asdasd"),
                                            );
                                          } else if (productState
                                          is ProductLoading) {
                                            return Center(
                                              child:
                                              CircularProgressIndicator(),
                                            );
                                          } else if (productState
                                          is ProductInitial) {
                                            return Center(
                                              child:
                                              CircularProgressIndicator(),
                                            );
                                          } else if (productState
                                          is FetchFailedProduct) {
                                            scheduleMicrotask(() =>
                                                Navigator
                                                    .of(context)
                                                    .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductPage()),
                                                        (
                                                        Route<dynamic> route) =>
                                                    false));
                                            return CircularProgressIndicator();
                                          } else if (productState
                                          is SetProductItem) {
                                            return Container(
                                              child: Text("Loading"),
                                            );
                                          } else if (productState
                                          is setProductItemSuccess) {
                                            scheduleMicrotask(() =>
                                                Navigator.of(context).pushNamed(
                                                    "/product_details",
                                                    arguments: {
                                                      "isLogin": isLogin
                                                    }));
                                            return CircularProgressIndicator();
                                          } else if (productState
                                          is SingleProductLoaded) {
                                            return Container(
                                              child:
                                              Text(productState.toString()),
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
                                                child: Text(
                                                    productState.toString()),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      Container(
                                        child: Text("Home Body"),
                                      ),
                                      BlocBuilder<SuggestedBloc,
                                          SuggestedState>(
                                        bloc: BlocProvider.of<SuggestedBloc>(
                                            context),
                                        builder: (context,
                                            suggestedproductState) {
                                          if ((suggestedproductState
                                          is LoadedSuggestedProducts)) {
                                            if (
                                            suggestedproductState.productModel
                                                .data
                                                .length >
                                                0) {
                                              return ListView(
                                                shrinkWrap: true,
                                                physics:
                                                const NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Container(
                                                    padding:
                                                    EdgeInsets.only(left: 15),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(left: 20,
                                                              top: 15),
                                                          child: Text(
                                                            "Suggested Products",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .height *
                                                        .65,
                                                    padding: EdgeInsets.all(
                                                        30.0),
                                                    child: ListView.separated(
                                                      itemCount: suggestedproductState
                                                          .productModel
                                                          .data
                                                          .length,
                                                      scrollDirection:
                                                      Axis.vertical,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                ProductDetailsBloc>(
                                                                context)
                                                                .add(
                                                                SetProductIds(
                                                                    suggestedproductState
                                                                        .productModel
                                                                        .data[
                                                                    index]
                                                                        .products
                                                                        .productId,
                                                                    suggestedproductState
                                                                        .productModel
                                                                        .data[
                                                                    index]
                                                                        .products
                                                                        .categoryId,
                                                                    suggestedproductState
                                                                        .productModel
                                                                        .data[
                                                                    index]
                                                                        .products
                                                                        .subcategoryId));
                                                          },
                                                          child: Container(
                                                            width: 180,
                                                            height: 100,
                                                            padding:
                                                            EdgeInsets.only(
                                                                right: 0),
                                                            child: Card(
                                                              shape:
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10.0),
                                                              ),
                                                              elevation: 4,
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                    child:
                                                                    Container(
                                                                      child: Image
                                                                          .network(
                                                                          "https://ecotech.xixotech.net/public/" +
                                                                              suggestedproductState
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
                                                                      child:
                                                                      Container(
                                                                        child:
                                                                        IconButton(
                                                                          icon:
                                                                          Icon(
                                                                            Icons
                                                                                .shopping_cart,
                                                                            size:
                                                                            22,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            if (!isLogin) {
                                                                              Fluttertoast
                                                                                  .showToast(
                                                                                  msg: "You have to login first",
                                                                                  toastLength: Toast
                                                                                      .LENGTH_SHORT,
                                                                                  gravity: ToastGravity
                                                                                      .CENTER,
                                                                                  timeInSecForIos: 1);
                                                                            } else
                                                                            if (isLogin) {
                                                                              showModalBottomSheet(
                                                                                  isScrollControlled: true,
                                                                                  backgroundColor: Colors
                                                                                      .transparent,
                                                                                  context: context,
                                                                                  builder: (
                                                                                      context) =>
                                                                                      CustomCartBottomSheet(
                                                                                          suggestedproductState
                                                                                              .productModel
                                                                                              .data[index]
                                                                                              .products
                                                                                              .productId));
                                                                            }
                                                                          },
                                                                        ),
                                                                      )),

                                                                  Positioned(
                                                                      left: 90,
                                                                      top: 20,
                                                                      child:
                                                                      Container(
                                                                        width:
                                                                        200,
                                                                        child: Padding(
                                                                            padding: EdgeInsets
                                                                                .only(
                                                                                top: 0,
                                                                                left: 2,
                                                                                right: 2),
                                                                            child: Text(
                                                                              suggestedproductState
                                                                                  .productModel
                                                                                  .data[index]
                                                                                  .products
                                                                                  .productName,
                                                                              textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                              maxLines:
                                                                              1,
                                                                              overflow:
                                                                              TextOverflow
                                                                                  .ellipsis,
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight
                                                                                      .bold),
                                                                            )),
                                                                      )),
                                                                  Positioned(
                                                                      top: 40,
                                                                      left: 140,
                                                                      child:
                                                                      Container(
                                                                        width: 90,
                                                                        height:
                                                                        25,
                                                                        child: Padding(
                                                                            padding: EdgeInsets
                                                                                .only(
                                                                                top: 5),
                                                                            child: Text(
                                                                              "\$" +
                                                                                  suggestedproductState
                                                                                      .productModel
                                                                                      .data[index]
                                                                                      .products
                                                                                      .sellingPrice,
                                                                              textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                              style:
                                                                              TextStyle(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  fontSize: 15),
                                                                            )),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return index == 0
                                                            ? SizedBox(
                                                          height: 0,)
                                                            : index % 4 == 0
                                                            ? Container(
                                                            width: 200,
                                                            margin: EdgeInsets
                                                                .all(5),
                                                            height: 180,
                                                            color:
                                                            Colors.green,
                                                            child:
                                                            NativeAdmob(
                                                              adUnitID: NativeAd
                                                                  .testAdUnitId,
                                                              controller:
                                                              _nativeAdController,
                                                              type:
                                                              NativeAdmobType
                                                                  .full,
                                                              loading: Center(
                                                                  child:
                                                                  CircularProgressIndicator()),
                                                              error: Text(
                                                                  'failed to load'),
                                                            ))
                                                            : Container();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                            else {
                                              return Center(
                                                child: Text("No Products Show"),
                                              );
                                            }
                                          } else if (suggestedproductState
                                          is LoadingSuggestedProducts ||
                                              suggestedproductState is SuggestedInitial) {
                                            return Center(
                                              child:
                                              CircularProgressIndicator(),
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
                                                child: Text(
                                                    suggestedproductState
                                                        .toString()),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ]))
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        child: Text("Coming soon"),
                      );
                    }
                  } else if (mostpopularState is MostPopularProductLoading) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              SizedBox(
                height: 10,
              ),

              BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                  bloc: BlocProvider.of<ProductDetailsBloc>(context),
                  builder: (context, productdetailsState) {
                    if (productdetailsState is setSingleProductIdsSucess) {
                      scheduleMicrotask(() =>
                          Navigator.of(context).pushNamed(
                              "/product_details",
                              arguments: {"isLogin": isLogin}));
                      return CircularProgressIndicator();
                    } else if (productdetailsState is ProductDetailsInitial) {
                      return Container();
                    } else if (productdetailsState is GetSingleProductIds) {
                      return Container();
                    } else {
                      return Container();
                    }
                  }),

              SizedBox(height: 15),

              BlocBuilder<DealDetailsBloc, DealDetailsState>(
                  bloc: BlocProvider.of<DealDetailsBloc>(context),
                  builder: (context, dealDetailsState) {
                    if (dealDetailsState is DealsDetailsInitial) {
                      return Container();
                    }
                    else if (dealDetailsState is SetSuccessDealId) {
                      scheduleMicrotask(() =>
                          Navigator.of(context).pushNamed(
                              "/all_deals",
                              arguments: {
                                "deal_name": dealDetailsState.dealName
                              }
                          ));
                      return CircularProgressIndicator();
                    }
                    else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    checkLoginProduct();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(context, "all_notification");
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        print(message.data.toString());
        // flutterLocalNotificationsPlugin.show(
        //     notification.hashCode,
        //     notification.title,
        //     notification.body,
        //     NotificationDetails(
        //       android: AndroidNotificationDetails(
        //         channel.id,
        //         channel.name,
        //         channel.description,
        //         color: Colors.blue,
        //         playSound: true,
        //         icon: '@mipmap/ic_launcher',
        //       ),
        //     ));
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
        // Navigator.pushNamed(context, "/all_notification");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        // showDialog(
        //     context: context,
        //     builder: (_) {
        //       return AlertDialog(
        //         title: Text(notification.title),
        //         content: SingleChildScrollView(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [Text(notification.body)],
        //           ),
        //         ),
        //       );
        //     });
        // print(message.data.toString());
        Navigator.pushNamed(context, "/all_notification");
      }
    });
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
        BlocProvider.of<DealBloc>(context).add(FetchDeals());
        BlocProvider.of<CartBloc>(context).add(FetchUserCart());
        BlocProvider.of<PackageProductBloc>(context).add(FetchPackageProduct());
        BlocProvider.of<DiscountedProductBloc>(context)
            .add(FetchDiscountedProduct());
        BlocProvider.of<SuggestedBloc>(context).add(FetchSugggestedProducts());
      } else {
        isLogin = false;
        BlocProvider.of<LoginBloc>(context).add(SetLoginStatus(isLogin));
        BlocProvider.of<MostPopularBloc>(context)
            .add(FetchMostPopularProduct());
        BlocProvider.of<DealBloc>(context).add(FetchDeals());
        BlocProvider.of<ProductBloc>(context).add(FetchWithoutLoginProduct());
        BlocProvider.of<PackageProductBloc>(context).add(FetchPackageProduct());
        BlocProvider.of<DiscountedProductBloc>(context)
            .add(FetchDiscountedProduct());
        BlocProvider.of<SuggestedBloc>(context).add(FetchSugggestedProducts());
      }
    } else {
      isLogin = false;
      BlocProvider.of<LoginBloc>(context).add(SetLoginStatus(isLogin));
      BlocProvider.of<ProductBloc>(context).add(FetchWithoutLoginProduct());
      BlocProvider.of<MostPopularBloc>(context).add(FetchMostPopularProduct());
      BlocProvider.of<DealBloc>(context).add(FetchDeals());
      BlocProvider.of<PackageProductBloc>(context).add(FetchPackageProduct());
      BlocProvider.of<DiscountedProductBloc>(context)
          .add(FetchDiscountedProduct());
    }
  }
}
