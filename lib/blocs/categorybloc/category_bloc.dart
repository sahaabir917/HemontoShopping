import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/category/CategoryModel.dart';
import 'package:hemontoshoppin/services/Services.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  ApiService apiservices = ApiService();
  CategoryModel _categoryModel;

  @override
  CategoryState get initialState => CategoryInitial();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is FetchingAllCategory) {
      yield CategoryLoading();
      _categoryModel = await apiservices.getAllCategory();
      yield CategoryOperationSuccess(_categoryModel);
    }
    if (event is SetSelectedItemPosition) {
      var size = _categoryModel.data.length-1;
      print("size ${size}");
      for(var i=0;i<=size;i++){
        _categoryModel.data[i].isSelected = false;
      }
      _categoryModel.data[event.index].isSelected = true;
      yield CategoryOperationSuccess(_categoryModel);
    }
  }
}
