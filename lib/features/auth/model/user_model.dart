class UserModel {
  final String? fullName;
  final String email;
  final String password;

  UserModel({
    this.fullName,
    required this.email,
    required this.password,
  });

  // --- FUNGSI PENERJEMAH (DARI JSON KE OBJEK) ---
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
    );
  }

  // --- FUNGSI PENERJEMAH (DARI OBJEK KE JSON) ---
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }
}