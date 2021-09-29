part of 'subcategorywiseproduct_bloc.dart';

@immutable
abstract class SubCategoryWiseProductState{}

class SubcategoryWiseProductStateInital extends SubCategoryWiseProductState{}

class SubCatByProductLoaded extends SubCategoryWiseProductState{
  final ProductModel productModel;

  SubCatByProductLoaded(this.productModel);

}

class SubCatByProductLoading extends SubCategoryWiseProductState{}