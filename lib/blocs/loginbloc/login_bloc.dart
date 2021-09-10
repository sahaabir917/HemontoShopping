import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/LoginModel.dart';
import 'package:hemontoshoppin/services/Services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  ApiService apiservices = ApiService();
  LoginModel _loginModel;
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    if(event is FetchLogin){
      yield checkingLogin();
      _loginModel = await apiservices.UserLogin(event.username,event.password);
      print(_loginModel);
      yield LoginInOperationSuccess(_loginModel);
    }
  }

}