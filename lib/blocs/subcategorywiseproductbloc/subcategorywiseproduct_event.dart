part of 'subcategorywiseproduct_bloc.dart';

@immutable
abstract class SubCategoryWiseProductEvent {}

class FetchProductBySubCategory extends SubCategoryWiseProductEvent{
  final String subId;

  FetchProductBySubCategory(this.subId);
}