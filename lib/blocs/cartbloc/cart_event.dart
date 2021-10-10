part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class FetchUserCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final String quantity;

  AddToCart(this.productId, this.quantity);
}

class CheckOut extends CartEvent{}

class IncrementQuantity extends CartEvent{
  final String cartId;
  final String incrementOrDecrement;

  IncrementQuantity(this.cartId,this.incrementOrDecrement);
}
