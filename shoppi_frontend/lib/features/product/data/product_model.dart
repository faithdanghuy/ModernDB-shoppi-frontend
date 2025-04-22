class ProductModel {
  int? rating;
  String? id;
  String? name;
  String? description;
  double? price;
  int? storeId;
  int? stock;
  String? image;

  ProductModel({
    this.rating,
    this.id,
    this.name,
    this.description,
    this.price,
    this.storeId,
    this.stock,
    this.image,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    price = (json['price'] as num?)?.toDouble();
    storeId = json['store_id'];
    stock = json['stock'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'store_id': storeId,
      'stock': stock,
      'image': image,
    };
  }
}
