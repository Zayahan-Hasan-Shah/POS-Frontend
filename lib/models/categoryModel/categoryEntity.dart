class CategoryEntity {
  final int? id;
  final String name;
  final int? userId;

  CategoryEntity({
    this.id,
    required this.name,
    this.userId,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id']?.toInt(),
      name: json['name'] ?? '',
      userId: json['user_id']?.toInt(),
    );
  }

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity &&
        other.id == id &&
        other.name == name &&
        other.userId == userId;
  }

  @override
  int get hashCode => Object.hash(id, name, userId);
}
