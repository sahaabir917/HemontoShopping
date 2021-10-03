part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class UserCartOperationSucess extends CartState{
   final UserCartModel userCartModel;

  UserCartOperationSucess(this.userCartModel);

}

class AfterAddToCart extends CartState{}