import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/features/order/data/order_model.dart';
import 'package:shoppi_frontend/features/order/domain/order_repo.dart';
import 'package:shoppi_frontend/features/order/bloc/order_event.dart';
import 'package:shoppi_frontend/features/order/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(StateOrderInitial()) {
    on<EventGetOrder>(_onEventGetOrder);
    on<EventCreateOrder>(_onEventCreateOrder);
    on<EventOrderPayment>(_onEventOrderPayment);
  }

  FutureOr<void> _onEventGetOrder(
      EventGetOrder event, Emitter<OrderState> emit) async {
    try {
      Response response = await OrderRepository.instant.getOrder();
      if (response.statusCode == 200) {
        List<OrderModel> orders = List<OrderModel>.from(
            response.data['data'].map((x) => OrderModel.fromJson(x)));
        emit(StateGetOrder(
            success: true, message: response.data['message'], data: orders));
      } else {
        emit(StateGetOrder(success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateGetOrder(success: false, message: e.toString()));
    }
  }

  FutureOr<void> _onEventCreateOrder(
      EventCreateOrder event, Emitter<OrderState> emit) async {
    try {
      Response response = await OrderRepository.instant.createOrder(
        items: event.items,
      );
      if (response.statusCode == 201) {
        emit(
            StateCreateOrder(success: true, message: response.data['message']));
      } else {
        emit(StateCreateOrder(
            success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateCreateOrder(success: false, message: e.toString()));
    }
  }

  FutureOr<void> _onEventOrderPayment(
      EventOrderPayment event, Emitter<OrderState> emit) async {
    try {
      Response response = await OrderRepository.instant.orderPayment(
        orderId: event.id,
        items: event.items,
      );
      if (response.statusCode == 200) {
        emit(StateOrderPayment(
            success: true, message: response.data['message']));
      } else {
        emit(StateOrderPayment(
            success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateOrderPayment(success: false, message: e.toString()));
    }
  }
}
