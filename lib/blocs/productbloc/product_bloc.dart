import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ApiService apiservices = ApiService();
  ProductModel _productModel;

  @override
  ProductState get initialState => ProductInitial();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is FetchProduct) {
      yield ProductLoading();
      _productModel = await apiservices.getProductWithOutLogin();
      print(_productModel);
      yield ProductOperationSuccess(_productModel);
    } else if (event is LikeProduct) {
      yield ProductLoading();
      if(_productModel.products[event.index].isFavourite == true){
        _productModel.products[event.index].isFavourite = false;
      }
      else{
        _productModel.products[event.index].isFavourite = true;
      }
      yield ProductOperationSuccess(_productModel);
    }
  }
}
