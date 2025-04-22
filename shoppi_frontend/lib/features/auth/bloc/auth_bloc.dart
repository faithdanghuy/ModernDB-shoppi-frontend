import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/cores/store/store.dart';
import 'package:shoppi_frontend/features/auth/bloc/auth_event.dart';
import 'package:shoppi_frontend/features/auth/bloc/auth_state.dart';

import 'package:shoppi_frontend/features/auth/domain/auth_repository.dart';
import 'package:shoppi_frontend/features/auth/model/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<EventRegister>(_onEventRegister);
    on<EventLogin>(_onEventLogin);
  }

  FutureOr<void> _onEventRegister(
      EventRegister event, Emitter<AuthState> emit) async {
    try {
      Response response = await AuthRepository.instant.register(
        username: event.username,
        password: event.password,
        email: event.email,
        fullname: event.fullname,
        address: event.address,
        phone: event.phone,
      );
      if (response.statusCode == 201) {
        emit(StateRegister(success: true, message: response.data['message']));
      } else {
        // emit(StateRegister(success: false, message: response.data['message']));
        final error = response.data['errors'];
        if (error != null && error is List) {
          emit(StateRegister(success: false, message: error.first));
        } else {
          emit(
              StateRegister(success: false, message: response.data['message']));
        }
      }
    } catch (e) {
      emit(StateRegister(success: false, message: e.toString()));
      rethrow;
    }
  }

  FutureOr<void> _onEventLogin(
      EventLogin event, Emitter<AuthState> emit) async {
    try {
      Response response = await AuthRepository.instant
          .login(username: event.username, password: event.password);
      if (response.statusCode == 200) {
        UserModel userModel = UserModel.fromJson(response.data['user']);
        await CacheData.instant.setUserId(userModel.id ?? '');
        await CacheData.instant.setUsername(userModel.username ?? '');
        await CacheData.instant.setToken(userModel.accessToken ?? '');

        emit(StateLogin(
            success: true,
            message:
                "Login successfully with username: ${userModel.username ?? ''}",
            userModel: userModel));
      } else {
        // emit(StateLogin(success: false, message: response.data['message'], userModel: null));
        final error = response.data['errors'];
        if (error != null && error is List) {
          emit(StateLogin(success: false, message: error.first));
        } else {
          emit(StateLogin(success: false, message: response.data['message']));
        }
      }
    } catch (e) {
      emit(StateLogin(success: false, message: e.toString(), userModel: null));
      rethrow;
    }
  }
}
