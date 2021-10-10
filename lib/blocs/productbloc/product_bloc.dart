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
  ProductModel _singleProductModel;
  FailedModel _failedModel;
  String _singleProductId;
  var token;
  var userId;

  Products _productItem;

  @override
  ProductState get initialState => ProductInitial();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is FetchWithoutLoginProduct) {
      yield ProductLoading();
      // userId = await getUserId();
      // print("preferencehelperuserid ${userId}");
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
      var returnedModel;
      userId = await getUserId();
      token = await getJwtToken();
      await apiservices.updateLikeProduct(token, userId, event.product_id);
    } else if (event is FetchWithLoginMostPopularProduct) {
      yield ProductLoading();
      _mostPopularProductModel = await apiservices.getMostPopularProduct();
      yield LoadedMostPopularProduct(_mostPopularProductModel);
    } else if (event is SetProductItem) {
      _productItem = _productModel.data[event.index].products;
      yield setProductItemSuccess();
    } else if (event is getProductItem) {
      // yield ProductLoading();
      yield SingleProductLoaded(_productItem);
    }

    // else if (event is SetProductId) {
    //   _singleProductId = event.productId;
    //   yield setSingleProductIdSucess();
    // }

    else if (event is getProductId) {
      yield GetSingleProductId(_singleProductId);
    } else if (event is LoadingSingleProduct) {
      yield ProductLoading();
      userId = await getUserId();
      _singleProductModel =
          await apiservices.getProductDetails(event.productId, userId);
      yield LoadedSingleProduct(_singleProductModel);
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
