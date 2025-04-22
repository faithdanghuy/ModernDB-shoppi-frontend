import 'package:dio/dio.dart';
import 'package:shoppi_frontend/cores/constants/app_constants.dart';
import 'package:shoppi_frontend/cores/network/dio_network.dart';

class AuthRepository {
  AuthRepository._();
  static AuthRepository instant = AuthRepository._();

  Future login({required String username, required String password}) async {
    try {
      DioNetwork.instant.init();
      final response = await DioNetwork.instant.dio
          .post("${AppConstants.serviceAuth}/login", data: {
        "password": password,
        "username": username,
      });
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
      rethrow;
    }
  }

  Future register(
      {required String username,
      required String password,
      required String email,
      required String fullname,
      required String address,
      required String phone}) async {
    try {
      DioNetwork.instant.init();
      final response = await DioNetwork.instant.dio
          .post("${AppConstants.serviceAuth}/register", data: {
        "password": password,
        "username": username,
        "email": email,
        "full_name": fullname,
        "address": address,
        "phone_number": phone
      });
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
      rethrow;
    }
  }
}
