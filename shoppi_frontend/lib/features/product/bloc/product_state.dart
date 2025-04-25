import 'package:shoppi_frontend/features/product/data/product_model.dart';
import 'package:shoppi_frontend/features/product/data/review_model.dart';

class ProductState {
  const ProductState();
}

class ProductStateInitial extends ProductState {}

class StateProductList extends ProductState {
  final bool success;
  final String? message;
  final List<ProductModel>? data;

  const StateProductList({required this.success, this.message, this.data});
}

class StateProductDetail extends ProductState {
  final bool success;
  final String? message;
  final ProductModel? data;
  final List<ReviewModel>? dataReview;

  const StateProductDetail({
    required this.success,
    this.message,
    this.data,
    this.dataReview,
  });
}

class StateAddToCart extends ProductState {
  final bool success;
  final String? message;
  const StateAddToCart({required this.success, this.message});
}

class StateMyProduct extends ProductState {
  final bool success;
  final String? message;
  final List<ProductModel>? data;

  const StateMyProduct({required this.success, this.message, this.data});
}

class StateDeleteProduct extends ProductState {
  final bool success;
  final String? message;
  const StateDeleteProduct({required this.success, this.message});
}

class StateUpdateProduct extends ProductState {
  final bool success;
  final String? message;
  const StateUpdateProduct({required this.success, this.message});
}

class StateAddProduct extends ProductState {
  final bool success;
  final String? message;
  const StateAddProduct({required this.success, this.message});
}
