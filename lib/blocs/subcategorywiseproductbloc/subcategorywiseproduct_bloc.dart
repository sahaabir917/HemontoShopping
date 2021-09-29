import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/models/subcategory/SubcategoryModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'subcategorywiseproduct_event.dart';

part 'subcategorywiseproduct_state.dart';

class SubCategoryWiseProductBloc
    extends Bloc<SubCategoryWiseProductEvent, SubCategoryWiseProductState> {

  ProductModel _subcatByProduct;
  String _userId;
  ApiService apiservices = ApiService();

  @override
  SubCategoryWiseProductState get initialState =>
      SubcategoryWiseProductStateInital();

  @override
  Stream<SubCategoryWiseProductState> mapEventToState(
      SubCategoryWiseProductEvent event) async* {
        if(event is FetchProductBySubCategory){
          yield SubCatByProductLoading();
          _userId = await getUserId();
          _subcatByProduct = await apiservices.getSubcatByProduct(event.subId,_userId);
          yield SubCatByProductLoaded(_subcatByProduct);
        }
  }

  Future<String> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString("user_id");
    return userId;
  }
}
