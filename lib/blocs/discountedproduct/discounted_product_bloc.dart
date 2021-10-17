import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'discounted_product_event.dart';
part 'discounted_product_state.dart';

class DiscountedProductBloc extends Bloc<DiscountedProductEvent, DiscountedProductState> {
  ApiService apiservices = ApiService();
  ApiService withLoginProductApiService = ApiService();
  ProductModel _productModel;
  ProductModel _mostPopularProductModel;
  ProductModel _singleProductModel;
  FailedModel _failedModel;
  String _singleProductId;
  var token;
  var userId;

  @override
  DiscountedProductState get initialState => DiscountedProductInitial();

  @override
  Stream<DiscountedProductState> mapEventToState(DiscountedProductEvent event) async* {
    if(event is FetchDiscountedProduct){
      _productModel = await apiservices.getDiscountedProduct();
      print(_productModel);
      yield DiscountedProductLoaded(_productModel);
    }
  }
}
