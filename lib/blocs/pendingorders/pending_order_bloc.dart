import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/OrderModelproducts/PendingOrderModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:hemontoshoppin/util/UserInfoUtils.dart';

part 'pending_order_event.dart';

part 'pending_order_state.dart';

class PendingOrderBloc extends Bloc<PendingOrderEvent, PendingOrderState> {
  var page = 0;
  var lastpage = 1;
  List<Datum> fetchedproducts;
  List<Datum> allorderproducts = [];
  PendingOrderProductModel pendingOrderProductModel;
  String userId;
  String jwtToken;
  UserInfoUtils userInfoUtils = UserInfoUtils();
  ApiService apiservices = ApiService();

  @override
  PendingOrderState get initialState => PendingOrderInitial();

  @override
  Stream<PendingOrderState> mapEventToState(PendingOrderEvent event) async* {
    if (event is ResetPendingOrderPageNumber) {
      page = 0;
    } else if (event is FetchPendingOrder) {
      page++;
      print("page is :" + page.toString());
      if (page <= lastpage) {
        if (page == 1) {
          //create a progress indicator....
          yield LoadingPendingOrderProducts();
        }
        jwtToken = await userInfoUtils.getJwtToken();
        userId = await userInfoUtils.getUserId();
        var returnedModel = await apiservices.getPendingOrder(
            jwtToken, userId, page, "Pending");
        if (returnedModel is PendingOrderProductModel) {
          pendingOrderProductModel = returnedModel;
          fetchedproducts = pendingOrderProductModel.data;
          lastpage =pendingOrderProductModel.lastPage;
          page = pendingOrderProductModel.currentPage;
          allorderproducts.addAll(fetchedproducts);
          yield PendingOrderProductLoaded(allorderproducts,true);
        }
        else if(returnedModel is FailedModel){
          yield FailedToFetchPendingOrder();
        }
      }
      else{
        yield PendingOrderProductLoaded(allorderproducts,false);
      }
    }
  }
}
