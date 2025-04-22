class InputOrderModel {
  final String productId;
  final int quantity;

  InputOrderModel({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() =>
      {'productId': productId, 'quantity': quantity};
}
