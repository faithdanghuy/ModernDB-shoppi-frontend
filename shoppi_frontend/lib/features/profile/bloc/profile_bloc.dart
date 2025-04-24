import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/cores/store/store.dart';
import 'package:shoppi_frontend/features/profile/bloc/profile_event.dart';
import 'package:shoppi_frontend/features/profile/bloc/profile_state.dart';
import 'package:shoppi_frontend/features/auth/model/user_model.dart';

import 'package:shoppi_frontend/features/profile/domain/profile_repo.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<EventUpdateProfile>(_onEventUpdateProfile);
    on<EventGetProfile>(_onEventGetProfile);
  }

  FutureOr<void> _onEventUpdateProfile(
      EventUpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      Response response = await ProfileRepository.instant.updateProfile(
        email: event.email,
        fullname: event.fullname,
        address: event.address,
        phone: event.phone,
      );
      if (response.statusCode == 201) {
        emit(StateUpdateProfile(success: true, message: response.data['message']));
      } else {
        // emit(StateUpdateProfile(success: false, message: response.data['message']));
        final error = response.data['errors'];
        if (error != null && error is List) {
          emit(StateUpdateProfile(success: false, message: error.first));
        } else {
          emit(
              StateUpdateProfile(success: false, message: response.data['message']));
        }
      }
    } catch (e) {
      emit(StateUpdateProfile(success: false, message: e.toString()));
      rethrow;
    }
  }

  FutureOr<void> _onEventGetProfile(
      EventGetProfile event, Emitter<ProfileState> emit) async {
    try {
      Response response = await ProfileRepository.instant
          .getProfile();
      if (response.statusCode == 200) {
        UserModel userModel = UserModel.fromJson(response.data['data']);
        await CacheData.instant.setUserId(userModel.id ?? '');
        await CacheData.instant.setUsername(userModel.username ?? '');

        emit(StateGetProfile(
            success: true,
            message:
                "GetProfile successfully with username: ${userModel.username ?? ''}",
            userModel: userModel));
      } else {
        // emit(StateGetProfile(success: false, message: response.data['message'], userModel: null));
        final error = response.data['errors'];
        if (error != null && error is List) {
          emit(StateGetProfile(success: false, message: error.first));
        } else {
          emit(StateGetProfile(success: false, message: response.data['message']));
        }
      }
    } catch (e) {
      emit(StateGetProfile(success: false, message: e.toString(), userModel: null));
      rethrow;
    }
  }
}
