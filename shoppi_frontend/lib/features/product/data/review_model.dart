class ReviewModel {
  String? userId;
  String? fullName;
  String? comment;
  int? rating;

  ReviewModel({this.userId, this.comment, this.rating});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    comment = json['comment'];
    rating = json['rating'];
  }
}
