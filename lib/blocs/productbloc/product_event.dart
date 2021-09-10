part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class FetchProduct extends ProductEvent{}

class LikeProduct extends ProductEvent{
  final int index;

  LikeProduct(this.index);
}


