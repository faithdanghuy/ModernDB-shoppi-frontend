import 'package:shoppi_frontend/features/product/data/input_product_model.dart';

sealed class ProductEvent {
  const ProductEvent();
}

class EventProductList extends ProductEvent {
  const EventProductList();
}

class EventProductDetail extends ProductEvent {
  final String id;

  const EventProductDetail(this.id);
}

class EventAddToCart extends ProductEvent {
  final String id;

  const EventAddToCart(this.id);
}

class EventMyProduct extends ProductEvent {
  const EventMyProduct();
}

class EventDeleteProduct extends ProductEvent {
  final String id;

  const EventDeleteProduct(this.id);
}

class EventAddProduct extends ProductEvent {
  final InputProductModel inputProductModel;

  const EventAddProduct(this.inputProductModel);
}

class EventUpdateProduct extends ProductEvent {
  final InputProductModel inputProductModel;

  const EventUpdateProduct(this.inputProductModel);
}
