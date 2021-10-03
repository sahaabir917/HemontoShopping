import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/productbloc/product_bloc.dart';
import 'package:hemontoshoppin/blocs/subcategory_bloc/subcategory_bloc.dart';
import 'package:hemontoshoppin/blocs/subcategorywiseproductbloc/subcategorywiseproduct_bloc.dart';
import 'package:hemontoshoppin/bottomsheet/CustomCartBottomSheet.dart';

class ProductWithSubCategory extends StatefulWidget {
  const ProductWithSubCategory({Key key}) : super(key: key);

  @override
  _ProductWithSubCategoryState createState() => _ProductWithSubCategoryState();
}

class _ProductWithSubCategoryState extends State<ProductWithSubCategory> {
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
                              // IconButton(
                              //     icon: Icon(Icons.logout),
                              //     onPressed: () {
                              //       preferenceHelper.LogoutData();
                              //       BlocProvider.of<LoginBloc>(context)
                              //           .add(SetLoginStatus(false));
                              //       BlocProvider.of<MostPopularBloc>(context)
                              //           .add(FetchMostPopularProduct());
                              //       BlocProvider.of<ProductBloc>(context)
                              //           .add(FetchWithoutLoginProduct());
                              //     }),
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
              children: <Widget>[
                // BlocBuilder<SubCategoryWiseProductBloc,
                //     SubCategoryWiseProductState>(
                //   bloc: BlocProvider.of<SubCategoryWiseProductBloc>(context),
                //   builder: (context, subcatbyproductstate) {

                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "SubCategories",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    BlocBuilder<SubCategoryBloc, SubcategoryState>(
                        bloc: BlocProvider.of<SubCategoryBloc>(context),
                        builder: (context, subcategoryState) {
                          if (subcategoryState is SubcategoryInital) {
                            return Container();
                          } else if (subcategoryState is SubcategoryLoaded) {
                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                height: 80,
                                width: 120,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: subcategoryState
                                        .subcategoryModel.subcategories.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          BlocProvider.of<
                                                      SubCategoryWiseProductBloc>(
                                                  context)
                                              .add(FetchProductBySubCategory(
                                                  subcategoryState
                                                      .subcategoryModel
                                                      .subcategories[index]
                                                      .subId));
                                        },
                                        child: Container(
                                          height: 80,
                                          width: 120,
                                          child: Card(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                subcategoryState
                                                    .subcategoryModel
                                                    .subcategories[index]
                                                    .subcategoryName,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            );
                          } else {
                            return Container(
                              child: Text(""),
                            );
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Stack(
                        children: <Widget>[
                          Text(
                            "Category Wise Product",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    BlocBuilder<SubCategoryWiseProductBloc,
                            SubCategoryWiseProductState>(
                        bloc: BlocProvider.of<SubCategoryWiseProductBloc>(
                            context),
                        builder: (context, subcatbyproductstate) {
                          if (subcatbyproductstate
                              is SubcategoryWiseProductStateInital) {
                            return Container();
                          } else if (subcatbyproductstate
                              is SubCatByProductLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (subcatbyproductstate
                              is SubCatByProductLoaded) {
                            return subcatbyproductstate
                                        .productModel.data.length >
                                    0
                                ? Container(
                                    height: 280,
                                    padding: EdgeInsets.all(10.0),
                                    child: ListView.separated(
                                      itemCount: subcatbyproductstate
                                          .productModel.data.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            BlocProvider.of<ProductBloc>(
                                                    context)
                                                .add(SetProductId(
                                                    subcatbyproductstate
                                                        .productModel
                                                        .data[index]
                                                        .products
                                                        .productId));
                                          },
                                          child: Container(
                                            width: 230,
                                            padding: EdgeInsets.only(right: 0),
                                            child: Card(
                                              elevation: 4,
                                              child: Stack(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            40.0),
                                                    child: Container(
                                                      child: Image.network(
                                                          "https://ecotech.xixotech.net/public/" +
                                                              subcatbyproductstate
                                                                  .productModel
                                                                  .data[index]
                                                                  .products
                                                                  .imageOne),
                                                    ),
                                                  ),
                                                  BlocBuilder<LoginBloc,
                                                          LoginState>(
                                                      bloc: BlocProvider.of<
                                                          LoginBloc>(context),
                                                      builder: (context,
                                                          loginState) {
                                                        if (loginState
                                                            is AlreadyLogin) {
                                                          //hiding the shopping cart

                                                          return Positioned(
                                                              right: 0,
                                                              child: InkWell(
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      IconButton(
                                                                    icon: Icon(Icons
                                                                        .shopping_cart),
                                                                    onPressed:
                                                                        () {
                                                                      showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor: Colors
                                                                              .transparent,
                                                                          context:
                                                                              context,
                                                                          builder: (context) => CustomCartBottomSheet(subcatbyproductstate
                                                                              .productModel
                                                                              .data[index]
                                                                              .products
                                                                              .productId));
                                                                    },
                                                                  ),
                                                                ),
                                                              ));

                                                          //end of hiding shopping cart

                                                        } else if (loginState
                                                            is NoLogin) {
                                                          return Positioned(
                                                              right: 0,
                                                              child: InkWell(
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      IconButton(
                                                                    icon: Icon(Icons
                                                                        .shopping_cart),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          "/login_page");
                                                                    },
                                                                  ),
                                                                ),
                                                              ));
                                                        }
                                                      }),
                                                  Positioned(
                                                      bottom: 40,
                                                      child: Container(
                                                        width: 230,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0),
                                                            child: Text(
                                                              subcatbyproductstate
                                                                  .productModel
                                                                  .data[index]
                                                                  .products
                                                                  .productName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                      )),
                                                  Positioned(
                                                      bottom: 10,
                                                      child: Container(
                                                        width: 230,
                                                        height: 25,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5),
                                                            child: Text(
                                                              "\$" +
                                                                  subcatbyproductstate
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
                                                                      .black),
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
                                                  adUnitID:
                                                      NativeAd.testAdUnitId,
                                                  controller:
                                                      _nativeAdController,
                                                  type: NativeAdmobType.full,
                                                  loading: Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                  error: Text('failed to load'),
                                                ))
                                            : Container();
                                      },
                                    ),
                                  )
                                : Container(
                                    child: Center(
                                      child: Text(
                                        "No Product Found",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                    ),
                                  );
                          }
                        })
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
