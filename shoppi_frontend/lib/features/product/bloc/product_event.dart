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

class EventAddReview extends ProductEvent {
  final String id;
  final String reviewText;
  final int rating;

  const EventAddReview(this.id, this.reviewText, this.rating);
}
