import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/usercart/UserCartModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:hemontoshoppin/util/UserInfoUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  var token;
  var userId;
  var productId;
  var cartId;
  var incrementOrDecrement;
  var productQuantity;
  ApiService apiservices = ApiService();
  UserCartModel _userCartModel;
  FailedModel _failedModel;
  UserInfoUtils userInfoUtils = UserInfoUtils();

  @override
  CartState get initialState => CartInitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is FetchUserCart) {
      var returnedModel;
      userId = await userInfoUtils.getUserId();
      token = await userInfoUtils.getJwtToken();
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
      userId = await userInfoUtils.getUserId();
      token = await userInfoUtils.getJwtToken();
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
        yield fetchFailedCartProduct();
      }
    }
    else if(event is IncrementQuantity){
      var returnedModel;
      userId = await userInfoUtils.getUserId();
      token = await userInfoUtils.getJwtToken();
      cartId = event.cartId;
      incrementOrDecrement = event.incrementOrDecrement;
      returnedModel = await apiservices.updateCartQuantity(
          token, userId,cartId,incrementOrDecrement);
      if (returnedModel is UserCartModel) {
        _userCartModel = returnedModel;
        // yield cartUpdateSuccess();
        yield UserCartOperationSucess(_userCartModel);
      } else if (returnedModel is FailedModel) {
        _failedModel = returnedModel;
        yield fetchFailedCartProduct();
      }
    }
    else if(event is CheckOut){
      yield CartInitial();
      var returnedModel;
      userId = await userInfoUtils.getUserId();
      token = await userInfoUtils.getJwtToken();
      returnedModel = await apiservices.CheckOut(userId,token);
    }
  }

  // Future<String> getJwtToken() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var jwttoken = sharedPreferences.getString("jwtToken");
  //   return jwttoken;
  // }
  //
  // Future<String> getUserId() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var userId = sharedPreferences.getString("user_id");
  //   return userId;
  // }
}
