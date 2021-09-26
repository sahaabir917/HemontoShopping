part of 'product_bloc.dart';

@immutable
abstract class ProductState{}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState{}

class ProductOperationSuccess extends ProductState{

  final ProductModel productModel;

  ProductOperationSuccess(this.productModel);
}

class LoadedSingleProduct extends ProductState{
  final ProductModel productModel;

  LoadedSingleProduct(this.productModel);

}

class LoadedMostPopularProduct extends ProductState{
  final ProductModel mostPopularProducts;

  LoadedMostPopularProduct(this.mostPopularProducts);
}

class SingleProductLoaded extends ProductState {
  final Products  products;

  SingleProductLoaded(this.products);

}

class GetSingleProductId extends ProductState{

  final String productId;

  GetSingleProductId(this.productId);

}


class setProductItemSuccess extends ProductState{}

class FetchFailedProduct extends ProductState{}

class ProductFavourite extends ProductState{}

class setSingleProductIdSucess extends ProductState{}