class UserEntity {
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? address;
  final String? shopname;

  UserEntity({
    this.name,
    this.username,
    this.email,
    this.phone,
    this.address,
    this.shopname,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      shopname: json['shopname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (shopname != null) 'shopname': shopname,
    };
  }

  UserEntity copyWith({
    String? name,
    String? username,
    String? email,
    String? phone,
    String? address,
    String? shopname,
  }) {
    return UserEntity(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      shopname: shopname ?? this.shopname,
    );
  }
}