import 'package:dio/dio.dart';
import 'package:shoppi_frontend/cores/constants/app_constants.dart';
import 'package:shoppi_frontend/cores/network/dio_network.dart';
import 'package:shoppi_frontend/cores/store/store.dart';

class ProductRepository {
  ProductRepository._();
  static final ProductRepository instant = ProductRepository._();

  Future<Response> getAllProducts() async {
    try {
      DioNetwork.instant.init();
      final response = await DioNetwork.instant.dio.get(
        "${AppConstants.serviceProduct}/",
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> productDetail(String id) async {
    try {
      DioNetwork.instant.init();
      final response = await DioNetwork.instant.dio.get(
        "${AppConstants.serviceProduct}/$id",
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> addToCart(String id) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.post(
        AppConstants.serviceCart,
        data: {
          "userId": CacheData.instant.userId,
          "productId": id,
          "quantity": 1
        },
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }
}
