class CartEvent {
  const CartEvent();
}

class EventGetCart extends CartEvent {}

class EventAddToCart extends CartEvent {
  final String id;
  const EventAddToCart(this.id);
}

class EventUpdateCart extends CartEvent {
  final String id;
  final int quantity;
  const EventUpdateCart({required this.id, required this.quantity});
}

class EventModifyCart extends CartEvent {
  final String? id;
  final bool clear;
  const EventModifyCart({this.id, this.clear = false});
}
