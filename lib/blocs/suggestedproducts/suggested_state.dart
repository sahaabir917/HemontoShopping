part of 'suggested_bloc.dart';

@immutable
abstract class SuggestedState{}

class SuggestedInitial extends SuggestedState {}

class LoadedSuggestedProducts extends SuggestedState{
  final ProductModel productModel;

  LoadedSuggestedProducts(this.productModel);
}

class LoadingSuggestedProducts extends SuggestedState{}