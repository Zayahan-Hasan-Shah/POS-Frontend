abstract class InventoryEvent {}

class LoadInventory extends InventoryEvent {}

class AddProduct extends InventoryEvent {
  final String name;
  final double price;
  final int quantity;
  final int categoryId;

  AddProduct({
    required this.name,
    required this.price,
    required this.quantity,
    required this.categoryId,
  });
}

class UpdateProduct extends InventoryEvent {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final int categoryId;

  UpdateProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.categoryId,
  });
}

class DeleteProduct extends InventoryEvent {
  final int id;

  DeleteProduct({required this.id});
}
