import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
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
        body: BlocBuilder<ProductBloc, ProductState>(
          bloc: BlocProvider.of<ProductBloc>(context),
          builder: (context, productState) {
            if (productState is ProductOperationSuccess &&
                productState.productModel.products.length > 0) {
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Stack(
                      children: <Widget> [
                        Text("New Arrived",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                      ],
                    ),
                  ),
                  Container(
                    height: 230,
                    padding: EdgeInsets.all(10.0),
                    child: ListView.separated(
                      itemCount: productState.productModel.products.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 230,
                          padding: EdgeInsets.only(right: 10),
                          child: Card(
                            elevation: 4,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    child: Image.network(
                                        "https://ecotech.xixotech.net/public/" +
                                            productState.productModel
                                                .products[index].imageOne),
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    child: Container(
                                        child: productState.productModel
                                                .products[index].isFavourite
                                            ? IconButton(
                                                icon:
                                                    Icon(Icons.favorite_border),
                                                onPressed: () {
                                                  // BlocProvider.of<ProductBloc>(
                                                  //         context)
                                                  //     .add(LikeProduct(index));
                                                  // checkLoginStatus(context,index)
                                                  checkLoginStatus(
                                                      context, index);
                                                },
                                              )
                                            : IconButton(
                                                icon: Icon(Icons.favorite),
                                                onPressed: () {
                                                  // BlocProvider.of<ProductBloc>(
                                                  //         context)
                                                  //     .add(LikeProduct(index));
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
                                    bottom: 0,
                                    child: Container(
                                      width: 230,
                                      height: 25,
                                      color: Colors.blue,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            productState.productModel
                                                .products[index].productName,
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ))
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
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    BlocProvider.of<ProductBloc>(context).add(FetchProduct());
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
}
