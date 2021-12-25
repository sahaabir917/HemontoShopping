part of "deal_details_bloc.dart";

@immutable
abstract class DealDetailsState{}

class DealsDetailsInitial extends DealDetailsState{}

class SetSuccessDealId extends DealDetailsState{
  final String dealId;
  final String dealName;

  SetSuccessDealId(this.dealId, this.dealName);
}

class SingleDealIdLoaded extends DealDetailsState{
  final String dealId;
  final String page;

  SingleDealIdLoaded(this.dealId,this.page);

}

class LoadingDealDetailsProducts extends DealDetailsState{}

class LoadedDealProducts extends DealDetailsState{
  final List<Datum> allproducts;

  LoadedDealProducts(this.allproducts);



}

class NoMoreData extends DealDetailsState{}

class LoadPageNumber extends DealDetailsState{
  final int page;

  LoadPageNumber(this.page);
}

class ResetPageNumberSuccess extends DealDetailsState{}