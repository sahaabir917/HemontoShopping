import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:hemontoshoppin/util/UserInfoUtils.dart';
import 'package:meta/meta.dart';

part 'suggested_event.dart';

part 'suggested_state.dart';

class SuggestedBloc extends Bloc<SuggestedEvent, SuggestedState> {
  ApiService apiservices = ApiService();
  ApiService withLoginProductApiService = ApiService();
  ProductModel _suggestedProductModel;
  UserInfoUtils userInfoUtils = UserInfoUtils();

  @override
  SuggestedState get initialState =>SuggestedInitial();

  @override
  Stream<SuggestedState> mapEventToState(SuggestedEvent event) async*{
    if(event is FetchSugggestedProducts){
    yield LoadingSuggestedProducts();
     var userId = await userInfoUtils.getUserId();
     _suggestedProductModel =
     await apiservices.getSuggestedProducts(userId);
     if(_suggestedProductModel is ProductModel){
       yield LoadedSuggestedProducts(_suggestedProductModel);
     }
    }
  }
}
