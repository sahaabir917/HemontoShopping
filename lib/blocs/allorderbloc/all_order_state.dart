part of 'all_order_bloc.dart';

@immutable
abstract class AllOrderState{}

class AllOrderInitial extends AllOrderState{}

class AllOrderLoading extends AllOrderState{}

class AllOrderProductLoaded extends AllOrderState{
  final List<Datum> allOrder;
  final bool hasMoreData;

  AllOrderProductLoaded(this.allOrder,this.hasMoreData);

}

class FailedToFetchAllOrder extends AllOrderState{}

class LoadingAllOrderProducts extends AllOrderState{}