part of 'pending_order_bloc.dart';

@immutable
abstract class PendingOrderEvent {}

class FetchPendingOrder extends PendingOrderEvent{}

class ResetPendingOrderPageNumber extends PendingOrderEvent{}