import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/DealProducts/DealProductsModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:hemontoshoppin/util/UserInfoUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "deal_details_event.dart";
part "deal_details_state.dart";

class DealDetailsBloc extends Bloc<DealDetailsEvent,DealDetailsState> {

  String _dealId;
  String _dealName;
  var token;
  var userId;
  int page=0;
  int lastPage = 1;
  List<Datum> allproducts=[];
  UserInfoUtils userInfoUtils = UserInfoUtils();
  ApiService apiservices = ApiService();
  DealProductsModel dealProductsModels;
  @override
  DealDetailsState get initialState => DealsDetailsInitial();

  @override
  Stream<DealDetailsState> mapEventToState(DealDetailsEvent event) async* {
    if(event is setDealId){
      _dealId = event.dealId;
      _dealName = event.dealName;
      yield SetSuccessDealId(_dealId,_dealName);
    }
    else if(event is FetchDealId){
      page++;
      if(page<=lastPage){
        yield SingleDealIdLoaded(_dealId,page.toString());
      }
      else{
        yield LoadedDealProducts(allproducts);
      }
    }
    else if(event is GetDealsProducts){
      yield LoadedDealProducts(allproducts);
      String dealId = event.dealId;
      String page = event.page;
      bool isRefresh = event.isRefresh;

      if(!isRefresh){

        if(int.parse(event.page) ==1){
          yield LoadingDealDetailsProducts();
        }

        if(int.parse(event.page)<=lastPage){
          DealProductsModel dealProductsModel = await apiservices.getAllDealProducts(dealId,page);
          List<Datum> products = dealProductsModel.products.data;
          lastPage = dealProductsModel.products.lastPage;
          print("inside bloc $page and $lastPage");
          allproducts.addAll(products);
          print(dealProductsModel);
          yield LoadedDealProducts(allproducts);
        }
        else{
          yield LoadedDealProducts(allproducts);
        }


      }
      else{
        yield NoMoreData();
      }
    }
    else if (event is GetPageNumber){
      yield LoadPageNumber(page);
    }
    else if(event is ResetPageNumber){
      page = 0;
      allproducts.clear();
    }
  }

  // int getPageNumber(){
  //   return page;
  // }


}
