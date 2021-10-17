part of 'discounted_product_bloc.dart';

@immutable
abstract class DiscountedProductState{}

class DiscountedProductInitial extends DiscountedProductState{}

class DiscountedProductLoaded extends DiscountedProductState{
  final ProductModel productModel;

  DiscountedProductLoaded(this.productModel);
}