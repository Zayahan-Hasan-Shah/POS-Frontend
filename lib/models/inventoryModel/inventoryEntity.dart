class InventoryEntity {
  final int? id;
  final String name;
  final double price;
  final int quantity;
  final int? categoryId;
  final String? categoryName;

  InventoryEntity({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.categoryId,
    this.categoryName,
  });

  factory InventoryEntity.fromJson(Map<String, dynamic> json) {
    return InventoryEntity(
      id: json['id']?.toInt(),
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity']?.toInt() ?? 0,
      categoryId: json['category_id']?.toInt(),
      categoryName: json['category_name'],
    );
  }

  @override
  String toString() {
    return 'InventoryEntity(id: $id, name: $name, price: $price, quantity: $quantity, categoryId: $categoryId, categoryName: $categoryName)';
  }
}



