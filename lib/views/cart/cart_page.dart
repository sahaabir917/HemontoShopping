import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:hemontoshoppin/SharedPreference/PreferenceHelper.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static PreferenceHelper preferenceHelper = new PreferenceHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                title: Text("My Cart"),
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
                              //     }),

                              BlocBuilder<CartBloc, CartState>(
                                  bloc: BlocProvider.of<CartBloc>(context),
                                  builder: (context, cartState) {
                                    if (cartState is CartInitial) {
                                      return Stack(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                                Icons.shopping_cart_rounded),
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
                                            icon: Icon(
                                                Icons.shopping_cart_rounded),
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
                ])
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              //most popular products
              BlocBuilder<CartBloc, CartState>(
                bloc: BlocProvider.of<CartBloc>(context),
                builder: (context, cartState) {
                  if ((cartState is UserCartOperationSucess)) {
                    if (cartState.userCartModel.data.length > 0) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            children: [
                              Container(
                                child: ListView.builder(
                                    itemCount:
                                        cartState.userCartModel.data.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Card(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 85,
                                            child: Image.network(
                                                "https://ecotech.xixotech.net/public/" +
                                                    cartState
                                                        .userCartModel
                                                        .data[index]
                                                        .products
                                                        .imageOne),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  cartState
                                                      .userCartModel
                                                      .data[index]
                                                      .products
                                                      .productName,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                padding: EdgeInsets.only(left: 12),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 12),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(cartState
                                                        .userCartModel
                                                        .data[index]
                                                        .products
                                                        .sellingPrice),
                                                    Text("×"),
                                                    Text(cartState.userCartModel
                                                        .data[index].cartQuantity
                                                        .toString()),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: const Icon(
                                                          Icons.add_box),
                                                      onPressed: () {
                                                        BlocProvider.of<CartBloc>(context).add(IncrementQuantity(cartState.userCartModel.data[index].products.cartId,"1"));
                                                      }),
                                                  SizedBox(width: 10,),
                                                  Text(cartState
                                                      .userCartModel
                                                      .data[index]
                                                      .products
                                                      .cartQuantity),
                                                  SizedBox(width: 10,),
                                                  IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .indeterminate_check_box,
                                                      ),
                                                      onPressed: () {
                                                        BlocProvider.of<CartBloc>(context).add(IncrementQuantity(cartState.userCartModel.data[index].products.cartId,"0"));
                                                      }),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ));
                                    }),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * .8,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Cart is empty",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                      );
                    }
                  } else if (cartState is CartInitial) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (cartState is fetchFailedCartProduct) {
                    return Container();
                  }

                  else {
                    return Container(
                      child: Text(cartState.toString()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        child: BlocBuilder<CartBloc, CartState>(
          bloc: BlocProvider.of<CartBloc>(context),
          builder: (context, cartState) {
            if (cartState is UserCartOperationSucess) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: Colors.orange,
                child: InkWell(
                  onTap: () {
                    sslCommerzCustomizedCall(
                        cartState.userCartModel.totalPrice);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart_rounded),
                        onPressed: () {},
                      ),
                      Text(
                        "Checkout ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        cartState.userCartModel.totalPrice.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            } else if (cartState is CartInitial) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: Colors.orange,
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart_rounded),
                        onPressed: () {},
                      ),
                      Text(
                        "Checkout ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                child: Text(cartState.toString()),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> sslCommerzCustomizedCall(int totalPrice) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
            ipn_url: "https://ecotech.xixotech.net/public/checkouts/1",
            multi_card_name: "visa,master,bkash",
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: "ewu6059c1a35680b",
            store_passwd: "ewu6059c1a35680b@ssl",
            total_amount: totalPrice.toDouble(),
            tran_id: "custom_transaction_id"));

    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " + result.message + " code: " + result.code);
      print("haserror");
    } else {
      SSLCTransactionInfoModel model = result;
      BlocProvider.of<CartBloc>(context).add(CheckOut());
      BlocProvider.of<CartBloc>(context).add(FetchUserCart());
      print("transaction Id " + model.tranId);
      print("bank id :"  + model.bankTranId);
      print("result ${result.toString()}");
    }
  }
}
