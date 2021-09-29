
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/models/subcategory/SubcategoryModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'subcategory_event.dart';

part 'subcategory_state.dart';

class SubCategoryBloc extends Bloc<SubcategorytEvent, SubcategoryState> {
  var token;
  var userId;
  ApiService apiservices = ApiService();
  SubcategoryModel _subcategoryModel;
  @override
  SubcategoryState get initialState => SubcategoryInital();

  @override
  Stream<SubcategoryState> mapEventToState(SubcategorytEvent event) async*{
   if(event is GetSubCategoriesByCategory){
     yield SubCategoryLoading();
     var category_id = event.category_id;
     _subcategoryModel = await apiservices.getSubcategories(category_id);
     yield SubcategoryLoaded(_subcategoryModel);
   }
  }

}

