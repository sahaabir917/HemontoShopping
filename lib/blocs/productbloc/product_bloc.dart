import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ApiService apiservices = ApiService();
  ApiService withLoginProductApiService = ApiService();
  ProductModel _productModel;
  ProductModel _mostPopularProductModel;
  FailedModel _failedModel;
  var token;
  var userId;

  @override
  ProductState get initialState => ProductInitial();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is FetchWithoutLoginProduct) {
      yield ProductLoading();
      _productModel = await apiservices.getProductWithOutLogin();
      print(_productModel);
      yield ProductOperationSuccess(_productModel);
    } else if (event is ProductInitial) {
      yield ProductLoading();
    } else if (event is FetchWithLoginProduct) {
      var returnedModel;
      yield ProductLoading();
      token = await getJwtToken();
      userId = await getUserId();
      returnedModel = await apiservices.getProductWithLogin(token, userId);
      if (returnedModel is ProductModel) {
        _productModel = returnedModel;
        yield ProductOperationSuccess(returnedModel);
      } else if (returnedModel is FailedModel) {
        _failedModel = returnedModel;
        yield FetchFailedProduct();
      }
    } else if (event is LikeProduct) {
      yield ProductLoading();
      var returnedModel;
      if (_productModel.data[event.index].favourite == true) {
        userId = await getUserId();
        token = await getJwtToken();
        // returnedModel = await apiservices.getProductWithLogin(token, userId);
        _productModel.data[event.index].favourite = false;
      } else {
        _productModel.data[event.index].favourite = true;
      }
      yield ProductOperationSuccess(_productModel);
    } else if (event is FetchWithLoginMostPopularProduct) {
      yield ProductLoading();
      _mostPopularProductModel = await apiservices.getMostPopularProduct();
      yield LoadedMostPopularProduct(_mostPopularProductModel);
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
