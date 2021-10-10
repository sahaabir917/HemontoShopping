import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/favbloc/favbloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
class FavouritePafe extends StatefulWidget {
  const FavouritePafe({Key key}) : super(key: key);

  @override
  _FavouritePafeState createState() => _FavouritePafeState();
}

class _FavouritePafeState extends State<FavouritePafe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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



                              // Text(isLogin.toString()),


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

              Container(
                child: Text("No api Available. Coming Soon!"),
              )
              //start from here
              // BlocBuilder<FavBloc, FavState>(
              //   bloc: BlocProvider.of<FavBloc>(context),
              //   builder: (context, favstate) {
              //
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // BlocProvider.of<FavBloc>(context).add(FetchAllOrder());
  }
}
