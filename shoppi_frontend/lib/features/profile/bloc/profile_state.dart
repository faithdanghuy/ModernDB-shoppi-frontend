import 'package:shoppi_frontend/features/auth/model/user_model.dart';

class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class StateUpdateProfile extends ProfileState {
  final bool success;
  final String? message;

  const StateUpdateProfile({required this.success, required this.message});
}

class StateGetProfile extends ProfileState {
  final bool success;
  final String? message;
  final UserModel? userModel;

  const StateGetProfile({
    required this.success,
    required this.message,
    this.userModel,
  });
}
