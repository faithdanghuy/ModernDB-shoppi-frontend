import 'package:shoppi_frontend/features/order/data/order_model.dart';

class OrderState {
  const OrderState();
}

class StateOrderInitial extends OrderState {}

class StateGetOrder extends OrderState {
  final bool success;
  final String? message;
  final List<OrderModel>? data;

  StateGetOrder({required this.success, this.message, this.data});
}

class StateCreateOrder extends OrderState {
  final bool success;
  final String? message;

  StateCreateOrder({required this.success, this.message});
}

class StateOrderPayment extends OrderState {
  final bool success;
  final String? message;

  StateOrderPayment({required this.success, this.message});
}
