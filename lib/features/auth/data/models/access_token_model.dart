class AccessTokenModel {
  final String token;

  AccessTokenModel({required this.token});

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(
      token: json['token'],
    );
  }
}
