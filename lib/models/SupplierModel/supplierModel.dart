class Supplier {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String companyName;
  final DateTime? createdAt;

  Supplier({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    required this.companyName,
    this.createdAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      companyName: json['company_name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'company_name': companyName,
    };
  }

  Supplier copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? companyName,
    DateTime? createdAt,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
