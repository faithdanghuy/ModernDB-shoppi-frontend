import 'package:shoppi_frontend/features/order/data/input_order_model.dart';
import 'package:shoppi_frontend/features/product/data/product_model.dart';

class OrderModel {
  String? id;
  String? createdAt;
  String? totalAmount;
  String? status;
  List<OrderItemModel>? items;

  OrderModel(
      {this.id, this.createdAt, this.totalAmount, this.status, this.items});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['orderId'];
    createdAt = json['createdAt'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    if (json['items'] != null) {
      items = <OrderItemModel>[];
      json['items'].forEach((v) {
        items!.add(OrderItemModel.fromJson(v));
      });
    }
  }
}

class OrderItemModel {
  String? productId;
  int? quantity;
  ProductModel? product;

  OrderItemModel({this.productId, this.quantity, this.product});

  OrderItemModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    product = json['productDetails'] != null
        ? ProductModel.fromJson(json['productDetails'])
        : null;
  }

  InputOrderModel toInputOrderModel() {
    return InputOrderModel(productId: productId ?? '', quantity: quantity ?? 0);
  }
}
