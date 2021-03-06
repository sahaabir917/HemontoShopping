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
  String _singleProductCatId;
  String _singleProductSubCatId;
  var token;
  var userId;
  ProductModel _singleProductModel;
  ProductModel _relatedProducts;
  ApiService apiservices = ApiService();
  ApiService withLoginProductApiService = ApiService();
  @override
  ProductDetailsState get initialState => ProductDetailsInitial();

  @override
  Stream<ProductDetailsState> mapEventToState(ProductDetailsEvent event) async* {
    if(event is ProductDetailsInitial){}
    else if(event is SetProductIds){
      _singleProductId = event.productId;
      _singleProductCatId = event.categoryId;
      _singleProductSubCatId =event.subCategoryId;
      yield setSingleProductIdsSucess();
    }
    else if (event is getProductIds) {
      yield GetSingleProductIds(_singleProductId,_singleProductCatId,_singleProductSubCatId);
    }
    else if (event is LoadingSingleProducts) {
      yield ProductDetailsLoading();
      userId = await getUserId();
      print("my user Id $userId");
      _singleProductModel =
      await apiservices.getProductDetails(event.productId, userId);
      await apiservices.storeSuggestedProduct(userId,event.productCatId,event.productSubCatId);
      _relatedProducts = await apiservices.getRelatedProducts(event.productCatId,event.productSubCatId);
      yield LoadedSingleProducts(_singleProductModel,_relatedProducts);
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