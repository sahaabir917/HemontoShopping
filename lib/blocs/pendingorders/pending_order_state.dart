part of 'pending_order_bloc.dart';

@immutable
abstract class PendingOrderState{}

class PendingOrderInitial extends PendingOrderState{}

class PendingOrderLoading extends PendingOrderState{}

class PendingOrderProductLoaded extends PendingOrderState{
  final List<Datum> allPendingOrder;
  final bool hasMoreData;

  PendingOrderProductLoaded(this.allPendingOrder,this.hasMoreData);

}

class FailedToFetchPendingOrder extends PendingOrderState{}

class LoadingPendingOrderProducts extends PendingOrderState{}