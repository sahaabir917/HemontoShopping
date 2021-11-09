import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/FailedModel.dart';
import 'package:hemontoshoppin/models/LoginModel.dart';
import 'package:hemontoshoppin/services/Services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  ApiService apiservices = ApiService();
  LoginModel _loginModel;
  FailedModel _failedModel;
  bool isLogin;
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    if(event is FetchLogin){
      yield checkingLogin();
      var apiCallBackModel = await apiservices.UserLogin(event.username,event.password);
      if(apiCallBackModel is LoginModel){
        _loginModel = apiCallBackModel;
        yield LoginInOperationSuccess(apiCallBackModel);
      }
      else if (apiCallBackModel is FailedModel){
        _failedModel = apiCallBackModel;
        yield LoginFailed(apiCallBackModel);
        print(_failedModel);
      }
      print(_loginModel);

    }

    else if(event is SetLoginStatus){
      isLogin = event.loginStatus;
      if(isLogin == false){
        yield NoLogin(isLogin);
      }
      else{
        yield AlreadyLogin(isLogin);
      }
    }

  }
}