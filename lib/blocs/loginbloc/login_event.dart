part of 'login_bloc.dart';


@immutable
abstract class LoginEvent{}

class FetchLogin extends LoginEvent{
  final String username;
  final String password;

  FetchLogin(this.username, this.password);


}