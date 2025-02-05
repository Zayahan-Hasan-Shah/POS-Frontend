class SignupEntity {
  final String name;
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String shopName;
  final String shopAddress;

  SignupEntity({
    required this.name,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.shopName,
    required this.shopAddress,
  });

  // Method to convert to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': userName,
      'email': email,
      'phone_number': phoneNumber,
      'password_hash': password,
      'shopname': shopName,
      'shop_address': shopAddress,
    };
  }
}