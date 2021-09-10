part of 'product_bloc.dart';

@immutable
abstract class ProductState{}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState{}

class ProductOperationSuccess extends ProductState{

  final ProductModel productModel;

  ProductOperationSuccess(this.productModel);
}

class ProductFavourite extends ProductState{

}