import 'package:shoppi_frontend/features/order/data/input_order_model.dart';

class OrderEvent {
  const OrderEvent();
}

class EventGetOrder extends OrderEvent {}

class EventCreateOrder extends OrderEvent {
  final List<InputOrderModel> items;
  const EventCreateOrder({required this.items});
}

class EventOrderPayment extends OrderEvent {
  final String id;
  final List<InputOrderModel> items;
  const EventOrderPayment({required this.id, required this.items});
}
