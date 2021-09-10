part of 'login_bloc.dart';

@immutable
abstract class LoginState{}

class LoginInitial extends LoginState {}

class checkingLogin extends LoginState{}

class LoginInOperationSuccess extends LoginState{
    final LoginModel _loginModel;

  LoginInOperationSuccess(this._loginModel);

}