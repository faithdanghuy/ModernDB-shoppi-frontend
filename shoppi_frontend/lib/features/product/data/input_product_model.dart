class InputProductModel {
  String? productId;
  String name;
  String description;
  String price;
  String image =
      "https://cdn.create.web.com/images/industries/common/images/placeholder-product-image-sq.jpg";
  InputProductModel(
      {this.productId,
      required this.name,
      required this.description,
      required this.price});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'image': image,
      };
}
