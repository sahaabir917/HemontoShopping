part of "deal_details_bloc.dart";

@immutable
abstract class DealDetailsEvent {}

class FetchDealsProducts extends DealDetailsEvent{}

class setDealId extends DealDetailsEvent{
  final String dealId;
  final String dealName;

  setDealId(this.dealId, this.dealName);


}

class FetchDealId extends DealDetailsEvent{}

class GetDealsProducts extends DealDetailsEvent{
  final String dealId;
  final String page;
  final bool isRefresh;

  GetDealsProducts(this.dealId,this.page,this.isRefresh);

}

class GetPageNumber extends DealDetailsEvent{}

class ResetPageNumber extends DealDetailsEvent{}