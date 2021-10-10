import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/services/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favevent.dart';
part 'favstate.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  ApiService apiservices = ApiService();
  FailedModel _failedModel;
  String _singleProductId;
  var token;
  var userId;

  @override
  FavState get initialState => FavInitial();

  @override
  Stream<FavState> mapEventToState(FavEvent event) async* {
    if(event is FetchAllOrder){
      var returnedModel;
      token = await getJwtToken();
      userId = await getUserId();
      // returnedModel = await apiservices.getProductWithLogin(token, userId);
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