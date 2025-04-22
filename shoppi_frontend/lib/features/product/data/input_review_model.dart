class InputReviewModel {
  final String productId;
  final int rating;
  final String comment;

  InputReviewModel(
      {required this.productId, required this.rating, required this.comment});

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'rating': rating,
        'comment': comment,
      };
}
