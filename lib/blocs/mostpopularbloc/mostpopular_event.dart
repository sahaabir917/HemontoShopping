part of 'mostpopular_bloc.dart';


@immutable
abstract class MostPopularEvent {}

class FetchMostPopularProduct extends MostPopularEvent{}

class FetchWithLoginMostPopularProduct extends MostPopularEvent{}

