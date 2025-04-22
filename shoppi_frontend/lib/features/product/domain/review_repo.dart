import 'package:dio/dio.dart';
import 'package:shoppi_frontend/cores/constants/app_constants.dart';
import 'package:shoppi_frontend/cores/network/dio_network.dart';
import 'package:shoppi_frontend/features/product/data/input_review_model.dart';

class ReviewRepository {
  ReviewRepository._();
  static final ReviewRepository instant = ReviewRepository._();

  Future<Response> checkReviewable({required String id}) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.get(
        "${AppConstants.serviceGraph}/$id",
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> addReview(
      {required InputReviewModel inputReviewModel}) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.post(
        "${AppConstants.serviceGraph}/review",
        data: inputReviewModel.toJson(),
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }
}
