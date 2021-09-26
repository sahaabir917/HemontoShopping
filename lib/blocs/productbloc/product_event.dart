part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class FetchWithoutLoginProduct extends ProductEvent{}

class FetchWithLoginProduct extends ProductEvent{}



class FetchWithLoginMostPopularProduct extends ProductEvent{}

class LoadingSingleProduct extends ProductEvent{
  final String productId;

  LoadingSingleProduct(this.productId);

}

class LikeProduct extends ProductEvent{
  final String product_id;

  LikeProduct(this.product_id);

}

class SetProductItem extends ProductEvent{
  final int index;

  SetProductItem(this.index);

}

class SetProductId extends ProductEvent{
  final String productId;

  SetProductId(this.productId);
}

class getProductId extends ProductEvent{}

class getProductItem extends ProductEvent{}



