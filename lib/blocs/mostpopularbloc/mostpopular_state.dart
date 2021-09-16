part of 'mostpopular_bloc.dart';

@immutable
abstract class MostPopularState{}

class MostPopularInitial extends MostPopularState {}

class MostPopularProductLoading extends MostPopularState{}

class MostPopularProductOperationSuccess extends MostPopularState{

  final ProductModel productModel;

  MostPopularProductOperationSuccess(this.productModel);

}