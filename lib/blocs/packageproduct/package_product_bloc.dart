import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/models/usercart/UserCartModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'package_product_event.dart';

part 'package_product_state.dart';

class PackageProductBloc extends Bloc<PackageProductEvent, PackageProductState>
{
  ApiService apiservices = ApiService();
  ApiService withLoginProductApiService = ApiService();
  ProductModel _productModel;
  FailedModel _failedModel;
  String _singleProductId;
  var token;
  var userId;
  @override
  PackageProductState get initialState => PackageProductInitail();

  @override
  Stream<PackageProductState> mapEventToState(PackageProductEvent event) async*{
    if(event is FetchPackageProduct){
      _productModel = await apiservices.getPackageProduct();
      print(_productModel);
      yield PackageProductLoaded(_productModel);
    }
  }
}