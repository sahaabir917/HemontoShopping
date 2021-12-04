part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsState{}

class ProductDetailsInitial extends ProductDetailsState {}

class setSingleProductIdsSucess extends ProductDetailsState{}

class GetSingleProductIds extends ProductDetailsState{

  final String productId;
  final String productCatId;
  final String productSubCatId;

  GetSingleProductIds(this.productId,this.productCatId,this.productSubCatId);

}

class ProductDetailsLoading extends ProductDetailsState{

}

class LoadedSingleProducts extends ProductDetailsState{
  final ProductModel productModel;
  final ProductModel relatedProducts;

  LoadedSingleProducts(this.productModel,this.relatedProducts);

}