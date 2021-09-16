part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class FetchWithoutLoginProduct extends ProductEvent{}

class FetchWithLoginProduct extends ProductEvent{}

class FetchWithLoginMostPopularProduct extends ProductEvent{}

class LikeProduct extends ProductEvent{
  final int index;

  LikeProduct(this.index);
}


