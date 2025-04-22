class UserModel {
  String? id;
  DateTime? createdAt;
  String? updatedAt;
  String? fullName;
  String? address;
  String? email;
  String? username;
  String? phone;
  String? accessToken;
  String? refreshToken;
  UserModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.fullName,
    this.email,
    this.address,
    this.username,
    this.phone,
    this.accessToken,
    this.refreshToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    createdAt = json['created_at'] != null
        ? DateTime.parse(json['created_at']).toLocal()
        : null;
    updatedAt = json['updated_at'];
    fullName = json['full_name'];
    email = json['email'];
    address = json['address'];
    username = json['username'];
    phone = json['phone_number'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }
}
