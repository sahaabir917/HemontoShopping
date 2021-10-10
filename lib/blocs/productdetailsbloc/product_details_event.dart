part of 'product_details_bloc.dart';


@immutable
abstract class ProductDetailsEvent {}

class SetProductIds extends ProductDetailsEvent{
  final String productId;

  SetProductIds(this.productId);
}

class getProductIds extends ProductDetailsEvent{}

class LoadingSingleProducts extends ProductDetailsEvent{
  final String productId;

  LoadingSingleProducts(this.productId);

}

