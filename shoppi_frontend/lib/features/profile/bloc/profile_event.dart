sealed class ProfileEvent {
  const ProfileEvent();
}

final class EventUpdateProfile extends ProfileEvent {
  final String email;
  final String fullname;
  final String address;
  final String phone;

  const EventUpdateProfile({
      required this.email,
      required this.fullname,
      required this.address,
      required this.phone});
}

final class EventGetProfile extends ProfileEvent {
  const EventGetProfile();
}

