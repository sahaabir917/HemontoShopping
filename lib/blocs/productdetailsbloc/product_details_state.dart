part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsState{}

class ProductDetailsInitial extends ProductDetailsState {}

class setSingleProductIdsSucess extends ProductDetailsState{}

class GetSingleProductIds extends ProductDetailsState{

  final String productId;

  GetSingleProductIds(this.productId);

}

class ProductDetailsLoading extends ProductDetailsState{

}

class LoadedSingleProducts extends ProductDetailsState{
  final ProductModel productModel;

  LoadedSingleProducts(this.productModel);

}