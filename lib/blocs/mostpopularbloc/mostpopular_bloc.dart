import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/productModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mostpopular_event.dart';

part 'mostpopular_state.dart';


class MostPopularBloc extends Bloc<MostPopularEvent,MostPopularState>{

  ApiService apiservices = ApiService();
  ApiService withLoginProductApiService = ApiService();
  ProductModel _mostPopularProductModel;

  @override
  MostPopularState get initialState => MostPopularProductLoading();

  @override
  Stream<MostPopularState> mapEventToState(MostPopularEvent event) async* {
      if(event is FetchMostPopularProduct){
        yield MostPopularProductLoading();
        _mostPopularProductModel = await apiservices.getMostPopularProduct();
        yield MostPopularProductOperationSuccess(_mostPopularProductModel);
      }
  }
}

