import 'package:dio/dio.dart';
import 'package:shoppi_frontend/cores/constants/app_constants.dart';
import 'package:shoppi_frontend/cores/network/dio_network.dart';

class ProfileRepository {
  ProfileRepository._();
  static ProfileRepository instant = ProfileRepository._();

  Future getProfile() async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response =
          await DioNetwork.instant.dio.get(AppConstants.serviceUser);
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
      rethrow;
    }
  }

  Future updateProfile(
      {required String fullname,
      required String email,
      required String address,
      required String phone}) async {
    try {
      DioNetwork.instant.init(isAuth: true);
      final response = await DioNetwork.instant.dio.put(
        AppConstants.serviceUser,
        data: {
          "full_name": fullname,
          "email": email,
          "address": address,
          "phone_number": phone
        },
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
      rethrow;
    }
  }
}
