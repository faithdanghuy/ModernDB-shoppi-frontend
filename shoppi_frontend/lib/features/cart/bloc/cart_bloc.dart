import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/features/cart/bloc/cart_event.dart';
import 'package:shoppi_frontend/features/cart/bloc/cart_state.dart';
import 'package:shoppi_frontend/features/cart/data/cart_model.dart';
import 'package:shoppi_frontend/features/cart/domain/cart_repo.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(StateCartInitial()) {
    on<EventGetCart>(_onEventGetCart);
    on<EventAddToCart>(_onEventAddToCart);
    on<EventModifyCart>(_onEventModifyCart);
    on<EventUpdateCart>(_onEventUpdateCart);
  }

  FutureOr<void> _onEventGetCart(
      EventGetCart event, Emitter<CartState> emit) async {
    try {
      Response response = await CartRepository.instant.getCart();
      if (response.statusCode == 200) {
        List<CartItemModel> cart = List<CartItemModel>.from(
            response.data['cart'].map((x) => CartItemModel.fromJson(x)));
        emit(StateGetCart(
            success: true, message: response.data['message'], data: cart));
      } else {}
    } catch (e) {
      emit(StateGetCart(success: false, message: e.toString()));
    }
  }

  FutureOr<void> _onEventAddToCart(
      EventAddToCart event, Emitter<CartState> emit) async {
    try {
      Response response =
          await CartRepository.instant.addToCart(productId: event.id);
      if (response.statusCode == 200) {
        emit(StateAddToCart(success: true, message: response.data['message']));
      } else {
        emit(StateAddToCart(success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateAddToCart(success: false, message: e.toString()));
    }
  }

  FutureOr<void> _onEventUpdateCart(
      EventUpdateCart event, Emitter<CartState> emit) async {
    try {
      Response response = await CartRepository.instant.updateCart(
        productId: event.id,
        quantity: event.quantity,
      );
      if (response.statusCode == 200) {
        emit(StateUpdateCart(success: true, message: response.data['message']));
      } else {
        emit(
            StateUpdateCart(success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateUpdateCart(success: false, message: e.toString()));
    }
  }

  FutureOr<void> _onEventModifyCart(
      EventModifyCart event, Emitter<CartState> emit) async {
    try {
      Response response;
      if (event.clear) {
        response = await CartRepository.instant.modifyCart(
          clear: true,
        );
      } else {
        response = await CartRepository.instant
            .modifyCart(productId: event.id, clear: false);
      }
      if (response.statusCode == 200) {
        emit(StateModifyCart(success: true, message: response.data['message']));
      } else {
        emit(
            StateModifyCart(success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateModifyCart(success: false, message: e.toString()));
    }
  }
}
