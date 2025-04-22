import 'package:dio/dio.dart';
import 'package:shoppi_frontend/cores/constants/app_constants.dart';
import 'package:shoppi_frontend/cores/network/dio_network.dart';

class CartRepository {
  CartRepository._();
  static final CartRepository instant = CartRepository._();

  Future<Response> getCart() async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.get(
        AppConstants.serviceCart,
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> addToCart({
    required String productId,
    int quantity = 1,
  }) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.post(
        AppConstants.serviceCart,
        data: {
          "productId": productId,
          "quantity": quantity,
        },
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> updateCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.patch(
        AppConstants.serviceCart,
        data: {
          "productId": productId,
          "quantity": quantity,
        },
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> modifyCart({
    String? productId,
    bool clear = false,
  }) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.delete(
        AppConstants.serviceCart,
        data: {
          if (productId != null) "productId": productId,
          if (clear) "clear": true,
        },
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }
}
