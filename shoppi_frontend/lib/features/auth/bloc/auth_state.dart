import 'package:shoppi_frontend/features/auth/model/user_model.dart';

class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class StateRegister extends AuthState {
  final bool success;
  final String? message;

  const StateRegister({required this.success, required this.message});
}

class StateLogin extends AuthState {
  final bool success;
  final String? message;
  final UserModel? userModel;

  const StateLogin({
    required this.success,
    required this.message,
    this.userModel,
  });
}
