class ReviewState {
  const ReviewState();
}

class ReviewStateInitial extends ReviewState {}

class StateCheckReviewable extends ReviewState {
  final bool success;
  final String? message;
  final bool? result;

  const StateCheckReviewable(
      {required this.success, this.message, this.result});
}

class StateAddReview extends ReviewState {
  final bool success;
  final String? message;

  const StateAddReview({
    required this.success,
    this.message,
  });
}
