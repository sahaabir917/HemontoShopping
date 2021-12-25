import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/dealdetails/deal_details_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/productdetailsbloc/product_details_bloc.dart';
import 'package:hemontoshoppin/bottomsheet/CustomCartBottomSheet.dart';
import 'package:hemontoshoppin/util/checkingLoginutill.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DealPage extends StatefulWidget {
  @override
  _DealPageState createState() => _DealPageState();
}

class _DealPageState extends State<DealPage> {
  var isLogin;
  CheckingLoginUtil checkingLoginUtil = CheckingLoginUtil();
  ScrollController _scrollController = new ScrollController();
  ScrollController _controller;
  final _controller1 = ScrollController();

  var _listview;
  // var currentPosition =_scrollController.position.pixels;

  _ScrollPosition() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("position", _controller.position.pixels);
  }

  @override
  void initState() {
    BlocProvider.of<DealDetailsBloc>(context).add(ResetPageNumber());
    BlocProvider.of<DealDetailsBloc>(context).add(FetchDealId());
    _controller = ScrollController(initialScrollOffset: 0.0);
    _controller.addListener(_ScrollPosition);
    checkingUserLogin();
  }

  var toolbarTitle;
  final _nativeAdController = NativeAdmobController();
  final RefreshController refreshController =
  RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    // final arguments = ModalRoute.of(context).settings.arguments as Map;
    // print(arguments);
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      print(arguments['deal_name']);
      toolbarTitle = arguments['deal_name'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(toolbarTitle),
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
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<DealDetailsBloc, DealDetailsState>(
          bloc: BlocProvider.of<DealDetailsBloc>(context),
          builder: (context, dealDetailstState) {
            if (dealDetailstState is SingleDealIdLoaded) {
              BlocProvider.of<DealDetailsBloc>(context).add(GetDealsProducts(
                  dealDetailstState.dealId, dealDetailstState.page, false));
              return Container();
            } else if (dealDetailstState is LoadingDealDetailsProducts) {

              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (dealDetailstState is LoadedDealProducts) {
              refreshController.loadComplete();

              return Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 60),
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
                    BlocProvider.of<DealDetailsBloc>(context)
                        .add(FetchDealId());
                  },
                  child: ListView.separated(
                    key: PageStorageKey<String>('controllerA'),
                    controller: _controller,
                    itemCount: dealDetailstState
                        .allproducts.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          BlocProvider.of<ProductDetailsBloc>(context).add(
                              SetProductIds(
                                  dealDetailstState
                                      .allproducts
                                  [index].productId,
                                  dealDetailstState
                                      .allproducts[index].categoryId,
                                  dealDetailstState
                                      .allproducts[index].subcategoryId));
                        },
                        child: Padding(
                          child: Container(
                            width: 180,
                            height: 100,
                            padding: EdgeInsets.only(right: 0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 4,
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      child: Image.network(
                                          "https://ecotech.xixotech.net/public/" +
                                              dealDetailstState
                                                  .allproducts[index]
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
                                            Icons.shopping_cart,
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            if (!isLogin) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "You have to login first",
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIos: 1);
                                            } else if (isLogin) {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                  Colors.transparent,
                                                  context: context,
                                                  builder: (context) =>
                                                      CustomCartBottomSheet(
                                                          dealDetailstState
                                                              .allproducts[index]
                                                              .productId));
                                            }
                                          },
                                        ),
                                      )),

                                  Positioned(
                                      left: 90,
                                      top: 20,
                                      child: Container(
                                        width: 200,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, left: 2, right: 2),
                                            child: Text(
                                              dealDetailstState
                                                  .allproducts[index]
                                                  .productName,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      )),
                                  Positioned(
                                      top: 40,
                                      left: 140,
                                      child: Container(
                                        width: 90,
                                        height: 25,
                                        child: Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "\$" +
                                                  dealDetailstState
                                                      .allproducts[index]
                                                      .sellingPrice,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            )),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(4.0),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return index == 0 ?SizedBox(height:0) :index % 12 == 0
                          ? Container(
                          width: 200,
                          margin: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height*.15,
                          color: Colors.green,
                          child: NativeAdmob(
                            adUnitID: NativeAd.testAdUnitId,
                            controller: _nativeAdController,
                            type: NativeAdmobType.full,
                            loading:
                            Center(child: CircularProgressIndicator()),
                            error: Text('failed to load'),
                          ))
                          : Container();
                    },
                  ),

                ),
                height: MediaQuery.of(context).size.height ,
              );

            } else if (dealDetailstState is DealsDetailsInitial) {
              return Container();
            } else {
              return Container(
                height: 20,
                child: Text(dealDetailstState.toString()),
              );
            }
          }),
    );
  }



  void checkingUserLogin() async {
    isLogin = await checkingLoginUtil.isLogin();
  }
}
