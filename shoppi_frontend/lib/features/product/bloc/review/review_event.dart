import 'package:shoppi_frontend/features/product/data/input_review_model.dart';

sealed class ReviewEvent {
  const ReviewEvent();
}

class EventCheckReviewable extends ReviewEvent {
  final String id;
  const EventCheckReviewable({
    required this.id,
  });
}

class EventAddReview extends ReviewEvent {
  final InputReviewModel review;
  const EventAddReview({
    required this.review,
  });
}
