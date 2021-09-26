part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class checkingLogin extends LoginState {}

class LoginInOperationSuccess extends LoginState {
  final LoginModel loginModel;

  LoginInOperationSuccess(this.loginModel);
}

class LoginFailed extends LoginState{
  final FailedModel failedModel;

  LoginFailed(this.failedModel);

}

class NoLogin extends LoginState{
  final bool isLogin;

  NoLogin(this.isLogin);

}

class AlreadyLogin extends LoginState{
  final bool isLogin;

  AlreadyLogin(this.isLogin);
}

