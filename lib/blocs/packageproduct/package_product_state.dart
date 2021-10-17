part of 'package_product_bloc.dart';

@immutable
abstract class PackageProductState {}

class PackageProductInitail extends PackageProductState{}

class PackageProductLoaded extends PackageProductState{
  final ProductModel productModel;

  PackageProductLoaded(this.productModel);

}