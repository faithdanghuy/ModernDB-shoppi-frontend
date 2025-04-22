import 'package:shoppi_frontend/features/cart/data/cart_model.dart';

class CartState {
  const CartState();
}

class StateCartInitial extends CartState {}

class StateGetCart extends CartState {
  final bool success;
  final String? message;
  final List<CartItemModel>? data;

  StateGetCart({required this.success, this.message, this.data});
}

class StateAddToCart extends CartState {
  final bool success;
  final String? message;

  StateAddToCart({required this.success, this.message});
}

class StateUpdateCart extends CartState {
  final bool success;
  final String? message;

  StateUpdateCart({required this.success, this.message});
}

class StateModifyCart extends CartState {
  final bool success;
  final String? message;

  StateModifyCart({required this.success, this.message});
}
