import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hemontoshoppin/blocs/allorderbloc/all_order_bloc.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/pendingorders/pending_order_bloc.dart';
import 'package:hemontoshoppin/blocs/productdetailsbloc/product_details_bloc.dart';
import 'package:hemontoshoppin/util/checkingLoginutill.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _nativeAdController = NativeAdmobController();
  var isLogin;
  CheckingLoginUtil checkingLoginUtil = CheckingLoginUtil();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final RefreshController allOrderrefreshController =
      RefreshController(initialRefresh: false);
  ScrollController _controller;
  ScrollController _controller1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
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
                                    icon: Icon(Icons.shopping_cart_rounded),
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
                            } else if (cartState is UserCartOperationSucess) {
                              return Stack(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart_rounded),
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
                                          cartState.userCartModel.data.length
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
              }),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: TabBar(
                indicatorColor: Colors.grey,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(fontSize: 10.0),
                tabs: [
                  Tab(text: "Delivered Orders"),
                  Tab(text: "Pending Orders"),
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * .8,
                child: TabBarView(children: [
                  BlocBuilder<AllOrderBloc, AllOrderState>(
                      bloc: BlocProvider.of<AllOrderBloc>(context),
                      builder: (context, allOrdertState) {
                        if (allOrdertState is LoadingAllOrderProducts) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (allOrdertState is AllOrderProductLoaded) {
                          allOrdertState.hasMoreData == true
                              ? allOrderrefreshController.loadComplete()
                              : allOrderrefreshController.loadNoData();

                          return Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: SmartRefresher(
                              controller: allOrderrefreshController,
                              enablePullUp: true,
                              onRefresh: () async {
                                //create another pagebloc...
                                // final result = await getPassengerData(isRefresh: true);
                                // if (result) {
                                //   refreshController.refreshCompleted();
                                // } else {
                                //   refreshController.refreshFailed();
                                // }
                                // print("page Number: "+ DealDetailsBloc().getPageNumber().toString());
                                // BlocProvider.of<DealDetailsBloc>(context).add(GetPageNumber());
                                // BlocBuilder<DealDetailsBloc, DealDetailsState>(
                                //     bloc: BlocProvider.of<DealDetailsBloc>(context),
                                //     builder: (context, dealDetailstState) {
                                //       if(dealDetailstState is LoadPageNumber){
                                //         print(dealDetailstState.page);
                                //       }
                                //       else{
                                //         return;
                                //       }
                                //     });

                                allOrderrefreshController.refreshCompleted();
                              },
                              onLoading: () async {
                                // final result = await getPassengerData();
                                // if (result) {
                                //   refreshController.loadComplete();
                                // } else {
                                //   refreshController.loadFailed();
                                // }
                                // print("page Number: "+DealDetailsBloc().page.toString());
                                BlocProvider.of<AllOrderBloc>(context)
                                    .add(FetchAllOrder());
                              },
                              child: ListView.separated(
                                key: PageStorageKey<String>('controllerB'),
                                controller: _controller1,
                                itemCount: allOrdertState.allOrder.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      BlocProvider.of<ProductDetailsBloc>(
                                              context)
                                          .add(SetProductIds(
                                              allOrdertState
                                                  .allOrder[index].productId,
                                              allOrdertState
                                                  .allOrder[index].categoryId,
                                              allOrdertState.allOrder[index]
                                                  .subcategoryId));
                                    },
                                    child: Padding(
                                      child: Container(
                                        width: 180,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .22,
                                        padding: EdgeInsets.only(right: 0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 4,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      child: Image.network(
                                                        "https://ecotech.xixotech.net/public/" +
                                                            allOrdertState
                                                                .allOrder[index]
                                                                .imageOne,
                                                        width: width * .2,
                                                        height: height * .12,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                    ),
                                                    Text(
                                                      allOrdertState
                                                          .allOrder[index]
                                                          .orderStatus,
                                                      style: TextStyle(
                                                          color: allOrdertState
                                                                      .allOrder[
                                                                          index]
                                                                      .orderStatus ==
                                                                  "Pending"
                                                              ? Colors.blue
                                                              : Colors.red,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Container(
                                                height: height,
                                                width: width * .55,
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      width: width,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        "Order Id : " +
                                                            allOrdertState
                                                                .allOrder[index]
                                                                .generateOrdertitle,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      width: width,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        allOrdertState
                                                            .allOrder[index]
                                                            .productName,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width: width,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        allOrdertState
                                                                .allOrder[index]
                                                                .sellingPrice +
                                                            "×" +
                                                            allOrdertState
                                                                .allOrder[index]
                                                                .cartQuantity
                                                                .toString(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(4.0),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return index == 0
                                      ? SizedBox(height: 0)
                                      : index % 12 == 0
                                          ? Container(
                                              width: 200,
                                              margin: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .15,
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
                            height: MediaQuery.of(context).size.height * .82,
                          );
                        } else if (allOrdertState is AllOrderInitial) {
                          return Container();
                        } else if (allOrdertState is FailedToFetchAllOrder) {
                          //logout and send to the login page..
                          return Container(
                            child: Text("logout"),
                          );
                        } else {
                          return Container(
                            height: 20,
                            child: Text(allOrdertState.toString()),
                          );
                        }
                      }),
                  BlocBuilder<PendingOrderBloc, PendingOrderState>(
                      bloc: BlocProvider.of<PendingOrderBloc>(context),
                      builder: (context, pendingOrdertState) {
                        if (pendingOrdertState is LoadingPendingOrderProducts) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (pendingOrdertState
                            is PendingOrderProductLoaded) {
                          pendingOrdertState.hasMoreData == true
                              ? refreshController.loadComplete()
                              : refreshController.loadNoData();

                          return Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: SmartRefresher(
                              controller: refreshController,
                              enablePullUp: true,
                              onRefresh: () async {
                                //create another pagebloc...
                                // final result = await getPassengerData(isRefresh: true);
                                // if (result) {
                                //   refreshController.refreshCompleted();
                                // } else {
                                //   refreshController.refreshFailed();
                                // }
                                // print("page Number: "+ DealDetailsBloc().getPageNumber().toString());
                                // BlocProvider.of<DealDetailsBloc>(context).add(GetPageNumber());
                                // BlocBuilder<DealDetailsBloc, DealDetailsState>(
                                //     bloc: BlocProvider.of<DealDetailsBloc>(context),
                                //     builder: (context, dealDetailstState) {
                                //       if(dealDetailstState is LoadPageNumber){
                                //         print(dealDetailstState.page);
                                //       }
                                //       else{
                                //         return;
                                //       }
                                //     });

                                refreshController.refreshCompleted();
                              },
                              onLoading: () async {
                                // final result = await getPassengerData();
                                // if (result) {
                                //   refreshController.loadComplete();
                                // } else {
                                //   refreshController.loadFailed();
                                // }
                                // print("page Number: "+DealDetailsBloc().page.toString());
                                BlocProvider.of<PendingOrderBloc>(context)
                                    .add(FetchPendingOrder());
                              },
                              child: ListView.separated(
                                key: PageStorageKey<String>('controllerA'),
                                controller: _controller,
                                itemCount:
                                    pendingOrdertState.allPendingOrder.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      BlocProvider.of<ProductDetailsBloc>(
                                              context)
                                          .add(SetProductIds(
                                              pendingOrdertState
                                                  .allPendingOrder[index]
                                                  .productId,
                                              pendingOrdertState
                                                  .allPendingOrder[index]
                                                  .categoryId,
                                              pendingOrdertState
                                                  .allPendingOrder[index]
                                                  .subcategoryId));
                                    },
                                    child: Padding(
                                      child: Container(
                                        width: 180,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .22,
                                        padding: EdgeInsets.only(right: 0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 4,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      child: Image.network(
                                                        "https://ecotech.xixotech.net/public/" +
                                                            pendingOrdertState
                                                                .allPendingOrder[
                                                                    index]
                                                                .imageOne,
                                                        width: width * .2,
                                                        height: height * .12,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                    ),
                                                    Text(
                                                      pendingOrdertState
                                                          .allPendingOrder[
                                                              index]
                                                          .orderStatus,
                                                      style: TextStyle(
                                                          color: pendingOrdertState
                                                                      .allPendingOrder[
                                                                          index]
                                                                      .orderStatus ==
                                                                  "Pending"
                                                              ? Colors.blue
                                                              : Colors.red,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Container(
                                                height: height,
                                                width: width * .55,
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      width: width,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        "Order Id : " +
                                                            pendingOrdertState
                                                                .allPendingOrder[
                                                                    index]
                                                                .generateOrdertitle,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      width: width,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        pendingOrdertState
                                                            .allPendingOrder[
                                                                index]
                                                            .productName,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width: width,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        pendingOrdertState
                                                                .allPendingOrder[
                                                                    index]
                                                                .sellingPrice +
                                                            "×" +
                                                            pendingOrdertState
                                                                .allPendingOrder[
                                                                    index]
                                                                .cartQuantity
                                                                .toString(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(4.0),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return index == 0
                                      ? SizedBox(height: 0)
                                      : index % 12 == 0
                                          ? Container(
                                              width: 200,
                                              margin: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .15,
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
                            height: MediaQuery.of(context).size.height * .82,
                          );
                        } else if (pendingOrdertState is PendingOrderInitial) {
                          return Container();
                        } else if (pendingOrdertState
                            is FailedToFetchPendingOrder) {
                          //logout and send to the login page..
                          return Container(
                            child: Text("logout"),
                          );
                        } else {
                          return Container(
                            height: 20,
                            child: Text(pendingOrdertState.toString()),
                          );
                        }
                      }),
                ]))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // BlocProvider.of<DealDetailsBloc>(context).add(ResetPageNumber());
    // BlocProvider.of<DealDetailsBloc>(context).add(FetchDealId());

    BlocProvider.of<PendingOrderBloc>(context)
        .add(ResetPendingOrderPageNumber());
    BlocProvider.of<PendingOrderBloc>(context).add(FetchPendingOrder());

    BlocProvider.of<AllOrderBloc>(context).add(ResetAllOrderPageNumber());
    BlocProvider.of<AllOrderBloc>(context).add(FetchAllOrder());

    checkingUserLogin();
  }

  void checkingUserLogin() async {
    isLogin = await checkingLoginUtil.isLogin();
  }
}
