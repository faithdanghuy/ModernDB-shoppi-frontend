import 'package:dio/dio.dart';
import 'package:shoppi_frontend/cores/constants/app_constants.dart';
import 'package:shoppi_frontend/cores/network/dio_network.dart';
import 'package:shoppi_frontend/features/order/data/input_order_model.dart';

class OrderRepository {
  OrderRepository._();
  static final OrderRepository instant = OrderRepository._();

  Future<Response> getOrder() async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.get(
        AppConstants.serviceOrder,
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> createOrder({
    required List<InputOrderModel> items,
  }) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.post(
        "${AppConstants.serviceOrder}/add",
        data: {
          "items": items.map((e) => e.toJson()).toList(),
        },
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }

  Future<Response> orderPayment({
    required String orderId,
    required List<InputOrderModel> items,
  }) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.post(
        AppConstants.serviceOrder,
        data: {
          "orderId": orderId,
          "items": items.map((e) => e.toJson()).toList(),
        },
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response!;
      rethrow;
    }
  }
}
