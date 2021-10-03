import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/usercart/UserCartModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  var token;
  var userId;
  var productId;
  var productQuantity;
  ApiService apiservices = ApiService();
  UserCartModel _userCartModel;
  FailedModel _failedModel;

  @override
  CartState get initialState => CartInitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is FetchUserCart) {
      var returnedModel;
      userId = await getUserId();
      token = await getJwtToken();
      returnedModel = await apiservices.getUserCart(token, userId);
      if (returnedModel is UserCartModel) {
        _userCartModel = returnedModel;
        yield UserCartOperationSucess(_userCartModel);
        // yield ProductOperationSuccess(returnedModel);
      } else if (returnedModel is FailedModel) {
        _failedModel = returnedModel;
        // yield FetchFailedProduct();
      }
    } else if (event is AddToCart) {
      yield CartInitial();
      var returnedModel;
      userId = await getUserId();
      token = await getJwtToken();
      productId = event.productId;
      productQuantity = event.quantity;
      returnedModel = await apiservices.addToCart(
          token, userId, productId, productQuantity);
      if (returnedModel is UserCartModel) {
        _userCartModel = returnedModel;
        yield AfterAddToCart();
        yield UserCartOperationSucess(_userCartModel);
        // yield ProductOperationSuccess(returnedModel);
      } else if (returnedModel is FailedModel) {
        _failedModel = returnedModel;
        // yield FetchFailedProduct();
      }
    }
  }

  Future<String> getJwtToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwttoken = sharedPreferences.getString("jwtToken");
    return jwttoken;
  }

  Future<String> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString("user_id");
    return userId;
  }
}
