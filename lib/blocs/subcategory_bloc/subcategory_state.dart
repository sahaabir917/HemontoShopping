part of 'subcategory_bloc.dart';

@immutable
abstract class SubcategoryState{}

class SubcategoryInital extends SubcategoryState{}

class SubcategoryLoaded extends SubcategoryState{
  final SubcategoryModel subcategoryModel;

  SubcategoryLoaded(this.subcategoryModel);
}

class SubCategoryLoading extends SubcategoryState{}