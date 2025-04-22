class ReviewModel {
  String? userId;
  String? comment;
  int? rating;

  ReviewModel({this.userId, this.comment, this.rating});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    comment = json['comment'];
    rating = json['rating'];
  }
}
