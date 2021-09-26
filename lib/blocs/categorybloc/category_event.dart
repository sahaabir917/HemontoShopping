part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent{}

class FetchingAllCategory extends CategoryEvent{}

class FetchedAllCategory extends CategoryEvent{}

class SetSelectedItemPosition extends CategoryEvent{
  final int index;

  SetSelectedItemPosition(this.index);

}

