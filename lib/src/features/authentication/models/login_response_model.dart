class LoginResponseModel {
  final String userId;
  final String roleId;
  final String token;

  LoginResponseModel({
    required this.userId,
    required this.roleId,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      userId: json['user_id'],
      roleId: json['role_id'],
      token: json['token'],
    );
  }

  // Example role mapping (adjust according to your DB)
  String get role {
    if (roleId == "691f4401a1e5b703ff7df977") return "Landlord";
    else return "Tenant";
  }
}
