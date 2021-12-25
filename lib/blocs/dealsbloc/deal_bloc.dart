import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/blocs/discountedproduct/discounted_product_bloc.dart';
import 'package:hemontoshoppin/models/deal/DealModel.dart';
import 'package:hemontoshoppin/services/Services.dart';

part 'deal_event.dart';
part 'deal_state.dart';

class DealBloc extends Bloc<DealsEvent, DealsState> {

  ApiService apiservices = ApiService();
  DealModel _dealModel;

  @override
  DealsState get initialState => DealsInitial();

  @override
  Stream<DealsState> mapEventToState(DealsEvent event) async*{
    if(event is FetchDeals){
      _dealModel = await apiservices.getAllDeals();
      print(_dealModel);
      yield LoadedDeals(_dealModel);
    }
  }
}