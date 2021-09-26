part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState{}

class CategoryOperationSuccess extends CategoryState{

  final CategoryModel categoryModel;

  CategoryOperationSuccess(this.categoryModel);

}