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

final class EventVerifyPhone extends AuthEvent {
  final String phone;
  final String type;

  const EventVerifyPhone({
    required this.phone,
    required this.type,
  });
}

final class EventVerifyOTP extends AuthEvent {
  final String phone;
  final String otp;

  const EventVerifyOTP({
    required this.phone,
    required this.otp,
  });
}

final class EventUpdateNewPassword extends AuthEvent {
  final String newPassword;

  const EventUpdateNewPassword({
    required this.newPassword,
  });
}

final class EventAccountWeId extends AuthEvent {
  final String weId;

  const EventAccountWeId({
    required this.weId,
  });
}

final class EventAccountDetailId extends AuthEvent {
  final String accountId;

  const EventAccountDetailId({
    required this.accountId,
  });
}
