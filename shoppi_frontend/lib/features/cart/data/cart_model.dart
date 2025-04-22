class CartItemModel {
  String? productId;
  String? name;
  String? description;
  double? price;
  int? stock;
  int? quantity;
  String? image;

  CartItemModel({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.quantity,
    this.image,
  });

  CartItemModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    description = json['description'];
    price = (json['price'] as num?)?.toDouble();
    stock = json['stock'];
    quantity = json['quantity'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'quantity': quantity,
      'image': image,
    };
  }
}
