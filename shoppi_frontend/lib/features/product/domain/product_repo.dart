import 'package:dio/dio.dart';
import 'package:shoppi_frontend/cores/constants/app_constants.dart';
import 'package:shoppi_frontend/cores/network/dio_network.dart';
import 'package:shoppi_frontend/cores/store/store.dart';
import 'package:shoppi_frontend/features/product/data/input_product_model.dart';

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

  Future<Response> myProduct() async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.get(
        "${AppConstants.serviceStore}/my-product",
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> deleteProduct(String id) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.delete(
        "${AppConstants.serviceStore}/$id",
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> addProduct(InputProductModel inputProductModel) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.post(
        AppConstants.serviceStore,
        data: inputProductModel.toJson(),
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> updateProduct(InputProductModel inputProductModel) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.patch(
        "${AppConstants.serviceStore}/${inputProductModel.productId}",
        data: inputProductModel.toJson(),
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }
}
