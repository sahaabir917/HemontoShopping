import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  String _singleProductId;
  var token;
  var userId;
  ProductModel _singleProductModel;
  ApiService apiservices = ApiService();
  ApiService withLoginProductApiService = ApiService();
  @override
  ProductDetailsState get initialState => ProductDetailsInitial();

  @override
  Stream<ProductDetailsState> mapEventToState(ProductDetailsEvent event) async* {
    if(event is ProductDetailsInitial){}
    else if(event is SetProductIds){
      _singleProductId = event.productId;
      yield setSingleProductIdsSucess();
    }
    else if (event is getProductIds) {
      yield GetSingleProductIds(_singleProductId);
    }
    else if (event is LoadingSingleProducts) {
      yield ProductDetailsLoading();
      userId = await getUserId();
      _singleProductModel =
      await apiservices.getProductDetails(event.productId, userId);
      yield LoadedSingleProducts(_singleProductModel);
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