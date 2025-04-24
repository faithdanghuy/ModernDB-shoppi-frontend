sealed class AuthEvent {
  const AuthEvent();
}

final class EventRegister extends AuthEvent {
  final String username;
  final String password;
  final String email;
  final String fullname;
  final String address;
  final String phone;

  const EventRegister(
      {required this.username,
      required this.password,
      required this.email,
      required this.fullname,
      required this.address,
      required this.phone});
}

final class EventLogin extends AuthEvent {
  final String username;
  final String password;

  const EventLogin({
    required this.username,
    required this.password,
  });
}

