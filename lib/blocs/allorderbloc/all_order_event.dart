part of 'all_order_bloc.dart';

@immutable
abstract class AllOrderEvent {}

class FetchAllOrder extends AllOrderEvent{}

class ResetAllOrderPageNumber extends AllOrderEvent{}