part of 'deal_bloc.dart';

@immutable
abstract class DealsState{}

class DealsInitial extends DealsState{}

class LoadedDeals extends DealsState{
  final DealModel dealModel;

  LoadedDeals(this.dealModel);
}