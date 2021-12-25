import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/OrderModelproducts/PendingOrderModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:hemontoshoppin/util/UserInfoUtils.dart';

part 'all_order_event.dart';

part 'all_order_state.dart';

class AllOrderBloc extends Bloc<AllOrderEvent, AllOrderState> {
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
  AllOrderState get initialState => AllOrderInitial();

  @override
  Stream<AllOrderState> mapEventToState(AllOrderEvent event) async* {
    if (event is ResetAllOrderPageNumber) {
      page = 0;
    } else if (event is FetchAllOrder) {
      page++;
      print("page is :" + page.toString());
      if (page <= lastpage) {
        if (page == 1) {
          //create a progress indicator....
          yield LoadingAllOrderProducts();
        }
        jwtToken = await userInfoUtils.getJwtToken();
        userId = await userInfoUtils.getUserId();
        var returnedModel = await apiservices.getPendingOrder(
            jwtToken, userId, page, "Delivered");
        if (returnedModel is PendingOrderProductModel) {
          pendingOrderProductModel = returnedModel;
          fetchedproducts = pendingOrderProductModel.data;
          lastpage = pendingOrderProductModel.lastPage;
          page = pendingOrderProductModel.currentPage;
          allorderproducts.addAll(fetchedproducts);
          yield AllOrderProductLoaded(allorderproducts, true);
        } else if (returnedModel is FailedModel) {
          yield FailedToFetchAllOrder();
        }
      } else {
        yield AllOrderProductLoaded(allorderproducts, false);
      }
    }
  }
}
