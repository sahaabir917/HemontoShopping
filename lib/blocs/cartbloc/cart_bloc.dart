import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hemontoshoppin/models/category/CategoryModel.dart';
import 'package:hemontoshoppin/services/Services.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent,CartState>{

  @override
  CartState get initialState =>CartInitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {

  }
}