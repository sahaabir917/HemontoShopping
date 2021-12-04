part of 'product_details_bloc.dart';


@immutable
abstract class ProductDetailsEvent {}

class SetProductIds extends ProductDetailsEvent{
  final String productId;
  final String categoryId;
  final String subCategoryId;

  SetProductIds(this.productId,this.categoryId,this.subCategoryId);
}

class getProductIds extends ProductDetailsEvent{}

class LoadingSingleProducts extends ProductDetailsEvent{
  final String productId;
  final String productCatId;
  final String productSubCatId;

  LoadingSingleProducts(this.productId,this.productCatId,this.productSubCatId);

}

