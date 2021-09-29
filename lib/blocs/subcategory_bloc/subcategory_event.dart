part of 'subcategory_bloc.dart';

@immutable
abstract class SubcategorytEvent {}

class GetSubCategoriesByCategory extends SubcategorytEvent{
  final String category_id;

  GetSubCategoriesByCategory(this.category_id);

}

