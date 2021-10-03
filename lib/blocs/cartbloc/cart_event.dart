part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class FetchUserCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final String quantity;

  AddToCart(this.productId, this.quantity);
}
